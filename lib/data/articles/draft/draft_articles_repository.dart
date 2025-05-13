import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:journal/data/api/article/requests/user_id_and_draft_article_id_request_body.dart';
import 'package:journal/data/api/draft/create_article_request_dto.dart';
import 'package:journal/data/api/draft/fetch_draft_article_request_dto.dart';
import 'package:journal/data/api/draft/save_article_request_dto.dart';
import 'package:journal/data/api_service.dart';
import 'package:journal/data/tag/tag_repository.dart';
import 'package:journal/di/domain_di.dart';
import 'package:journal/domain/articles/entities/draft_article.dart';
import 'package:journal/presentations/article/details/article_details_provider.dart';

final class DraftArticlesRepository {
  final _userSettings = DomainDi().userSettings;
  final _apiClient = ApiService.client;

  Future<int> saveDraft(DraftArticle draft) async {
    final userId = (await _userSettings.id)!;
    final requestBody = SaveArticleRequestDto(
      draftId: draft.id,
      userId: userId,
      title: draft.title,
      contents:
          draft.body.isNotEmpty
              ? draft.body
                  .map((component) => jsonEncode(component.toMap()))
                  .toList()
              : null,
      subtitle: draft.subtitle.isNotEmpty ? draft.subtitle : null,
      tags:
          draft.tags.isNotEmpty
              ? draft.tags.map((tag) => tag.name).toList()
              : null,
    );

    final response = await _apiClient.saveDraftArticle(requestBody);
    return response['id']!;
  }

  Future<int> createDraft(DraftArticle draft) async {
    log('create draft called: $draft}');

    final requestBody = CreateArticleRequestDto(
      authorIds: draft.authors.map((it) => it.authorId).toList(),
      title: draft.title,
      subtitle: draft.subtitle,
      contents: draft.body.map((it) => jsonEncode(it.toMap())).toList(),
    );

    final response = await _apiClient.createDraftArticle(requestBody);

    return response['id']!;
  }

  Future<List<DraftArticle>> fetchAllDraftsByUserId(int userId) async {
    final response = await _apiClient.fetchDraftArticlesByUserId(userId);

    return response.map((draft) {
      return DraftArticle(
        id: draft.id,
        authors:
            draft.authors.map((it) {
              return ArticleAuthors(
                author: it.authorName,
                authorId: it.authorId,
                authorDescription: it.authorDescription,
                followers: it.followers,
                isFollowed: it.isFollowed,
                authorAvatarUrl: it.authorAvatarBytes,
              );
            }).toList(),
        title: draft.title,
        subtitle: draft.subtitle,
        body: [],
        tags: [],
        createdDate: draft.createdAt,
        lastUpdatedDate: draft.updatedAt,
      );
    }).toList();
  }

  Future<DraftArticle?> fetchById(int draftId) async {
    final userId = (await _userSettings.id)!;
    final response = await _apiClient.fetchDraftArticleById(
      FetchDraftArticleRequestDto(userId: userId, draftArticleId: draftId),
    );

    return DraftArticle(
      id: response.id,
      authors:
          response.authors.map((it) {
            return ArticleAuthors(
              author: it.authorName,
              authorId: it.authorId,
              authorDescription: it.authorDescription,
              followers: it.followers,
              isFollowed: it.isFollowed,
              authorAvatarUrl: it.authorAvatarBytes,
            );
          }).toList(),
      title: response.title,
      subtitle: response.subtitle,
      body:
          response.contents
              .map((content) => BodyComponent.fromMap(content))
              .toList(),
      tags: response.tags.map((tag) => Tag(tag)).toList(),
      createdDate: response.createdAt,
      lastUpdatedDate: response.updatedAt,
    );
  }

  Future<void> publish(int draftArticleId) async {
    final userId = (await _userSettings.id)!;

    await _apiClient.publish(UserIdAndDraftArticleIdRequestBody(userId: userId, draftArticleId: draftArticleId));
  }

  Future<List<BodyComponent>> fixText(
    List<BodyComponent> bodyComponents,
  ) async {
    try {
      bodyComponents.sort((a, b) => a.order.compareTo(b.order));
      final text = bodyComponents
          .map(
            (component) => component is TextBodyComponent ? component.text : '',
          )
          .join('\n');

      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-3.5-turbo',
          'messages': [
            {
              'role': 'system',
              'content':
                  'Ты — помощник, который исправляет грамматические, пунктуационные и орфографические ошибки в тексте. Пользователь предпочитает, чтобы дублирующиеся строки не удалялись, а дублировались. Возвращай только исправленный текст без комментариев.',
            },
            {'role': 'user', 'content': text},
          ],
          'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(utf8.decode(response.bodyBytes));

        final content = decoded['choices'][0]['message']['content'].toString();
        final contentList = content.split('\n');

        List<BodyComponent> updatedComponents = [];
        int contentIndex = 0;

        for (var component in bodyComponents) {
          switch (component) {
            case TextBodyComponent(order: final order):
              updatedComponents.add(
                TextBodyComponent(
                  order: order,
                  text: contentList[contentIndex],
                ),
              );
              break;

            case ImageBodyComponent(
              order: final order,
              description: final description,
              imageBytes: final imageBytes,
            ):
              updatedComponents.add(
                ImageBodyComponent(
                  order: order,
                  description: description,
                  imageBytes: imageBytes,
                ),
              );
              break;

            case ChartBodyComponent(order: final order):
              updatedComponents.add(
                ChartBodyComponent(
                  order: order,
                  points: component.points,
                  title: component.title,
                  chartType: component.chartType,
                ),
              );
              break;
          }
        }

        return updatedComponents;
      } else {
        throw Exception('Ошибка при исправлении текста');
      }
    } catch (e) {
      throw Exception('Ошибка при исправлении текста: $e');
    }
  }

  static const _apiKey = '';
}

final class DraftArticleContent {
  final int draftArticleContentId;
  final int draftArticleId;
  final Map<String, dynamic> content;

  const DraftArticleContent({
    required this.draftArticleContentId,
    required this.draftArticleId,
    required this.content,
  });
}

final class DraftArticleDataEntity {
  final int id;
  final int userId;
  final String title;
  final String subtitle;
  final int createdDate;
  final bool isPublished;

  const DraftArticleDataEntity({
    required this.id,
    required this.userId,
    required this.title,
    required this.subtitle,
    required this.createdDate,
    required this.isPublished,
  });

  DraftArticleDataEntity copyWith({
    int? id,
    int? userId,
    String? title,
    String? subtitle,
    int? createdDate,
    bool? isPublished,
  }) {
    return DraftArticleDataEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      createdDate: createdDate ?? this.createdDate,
      isPublished: isPublished ?? this.isPublished,
    );
  }
}

final class DraftArticleHistory {
  final int draftArticleId;
  final int updatedDate;

  const DraftArticleHistory({
    required this.draftArticleId,
    required this.updatedDate,
  });
}

final class DraftArticleTag {
  final int draftArticleId;
  final String tagId;

  const DraftArticleTag({required this.draftArticleId, required this.tagId});
}

final class ArticleNotFoundException implements Exception {}
