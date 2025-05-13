import 'dart:async';

import 'package:journal/common/utils/datetime_utils.dart';
import 'package:journal/data/api/article/requests/fetch_all_article_by_author_request_dto.dart';
import 'package:journal/data/api/article/requests/fetch_article_by_id_request_body.dart';
import 'package:journal/data/api/article/requests/user_id_and_article_id_request_body.dart';
import 'package:journal/data/api/article/requests/user_id_and_draft_article_id_request_body.dart';
import 'package:journal/data/api_service.dart';
import 'package:journal/domain/articles/entities/article_list_preview.dart';
import 'package:journal/domain/articles/entities/draft_article.dart';
import 'package:journal/domain/users/users_settings.dart';
import 'package:journal/presentations/article/details/article_details_provider.dart';
import 'package:journal/presentations/article/details/entities/ui_comment.dart';
import 'package:journal/presentations/widgets/article_list_card.dart';

final class ArticlesRepository {
  final _apiClient = ApiService.client;

  final UserSettings _userSettings;

  ArticlesRepository({required UserSettings userSettings})
    : _userSettings = userSettings;

  Future<List<ArticleListPreviewEntity>> getAllArticles({
    required int page,
    required int limit,
    String? searchQuery,
    String? selectedTag,
  }) async {
    final userId = (await _userSettings.id)!;

    final response = await _apiClient.getArticleList(userId);

    final articles = response;

    final List<ArticleListPreviewEntity> result =
        articles.map((article) {
          final authors =
              article.authors.map((author) {
                return ArticleAuthorUi(
                  author: author.authorName,
                  authorBytes: author.authorAvatarBytes,
                );
              }).toList();

          return ArticleListPreviewEntity(
            id: article.id,
            title: article.title,
            subtitle: article.subtitle,
            imageBytes: article.imageBytes,
            authors: authors,
            likes: article.likes,
            comments: article.comments,
            createdAt: formatDate(article.createdAt),
          );
        }).toList();

    return result;
  }

  Future<ArticleDetailsEntity> getArticleById(int id) async {
    final userId = (await _userSettings.id)!;
    final response = await _apiClient.getArticleById(
      FetchArticleByIdRequestBody(userId: userId, articleId: id),
    );

    final isCurrentAuthor =
        response.authors
            .where((author) => author.authorId == userId)
            .isNotEmpty;

    final username = (await _userSettings.username)!;

    return ArticleDetailsEntity(
      id: response.id,
      title: response.title,
      imageUrl: response.imageBytes,
      authors:
          response.authors
              .map(
                (author) => ArticleAuthors(
                  authorId: author.authorId,
                  author: author.authorName,
                  authorDescription: author.authorDescription,
                  followers: author.followers,
                  isFollowed: author.isFollowed,
                ),
              )
              .toList(),

      date: formatDate(response.createdDate),
      readTime: response.readTime,
      content:
          response.content.map((item) => BodyComponent.fromMap(item)).toList(),
      tags: response.tags,
      comments:
          response.comments.map((comment) {
            return UiComment(
              id: comment.id,
              authorId: comment.authorId,
              author: comment.author,
              articleId: comment.articleId,
              datetime: comment.createdAt,
              likes: comment.likes,
              isLiked: comment.isLiked,
              text: comment.text,
            );
          }).toList(),
      likes: response.likes,
      isLiked: response.isLiked,
      currentUsername: username,
      currentUserAvatarBytes: (await _userSettings.avatarBytes),
      isCurrentUserAuthor: isCurrentAuthor,
    );
  }

  Future<List<ArticleListPreviewEntity>> getArticlesByUserId(int userId) async {
    final currentUserId = (await _userSettings.id)!;

    final response = await _apiClient.getArticlesByAuthor(
      FetchAllArticleByAuthorRequestDto(
        userId: currentUserId,
        authorId: userId,
      ),
    );

    return response
        .map(
          (article) => (ArticleListPreviewEntity(
            title: article.title,
            subtitle: article.subtitle,
            likes: article.likes,
            authors:
                article.authors.map((author) {
                  return ArticleAuthorUi(
                    author: author.authorName,
                    authorBytes: author.authorAvatarBytes,
                  );
                }).toList(),
            comments: article.comments,
            createdAt: formatDate(article.createdAt),
            id: article.id,
            imageBytes: article.imageBytes,
          )),
        )
        .toList();
  }

  Future<void> likeArticle(int articleId) async {
    final currentUserId = (await _userSettings.id)!;

    await _apiClient.likeArticle(
      UserIdAndArticleIdRequestBody(
        userId: currentUserId,
        articleId: articleId,
      ),
    );
  }

  Future<void> publishArticle(int draftArticleId) async {
    final currentUserId = (await _userSettings.id)!;

    await _apiClient.publish(
      UserIdAndDraftArticleIdRequestBody(
        userId: currentUserId,
        draftArticleId: draftArticleId,
      ),
    );
  }
}

final class DataBodyComponent {
  final int articleId;
  final int order;
  final String content;

  const DataBodyComponent({
    required this.articleId,
    required this.order,
    required this.content,
  });

  DataBodyComponent copyWith({int? articleId, int? order, String? content}) {
    return DataBodyComponent(
      articleId: articleId ?? this.articleId,
      order: order ?? this.order,
      content: content ?? this.content,
    );
  }
}
