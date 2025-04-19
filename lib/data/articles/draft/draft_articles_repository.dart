import 'package:journal/data/tag/tag_repository.dart';
import 'package:journal/domain/articles/entities/draft_article.dart';

final class DraftArticlesRepository {
  static int _lastId = 0;

  final List<DraftArticleContent> _articleContents = [];

  final List<DraftArticleDataEntity> _draftArticles = [];

  final List<DraftArticleHistory> _draftArticleHistories = [];

  final List<DraftArticleTag> _draftArticleTags = [];

  Future<int> saveDraft(DraftArticle draft) async {
    try {
      _lastId++;

      var entity = DraftArticleDataEntity(
        id: _lastId,
        userId: draft.authorId,
        title: draft.title,
        subtitle: draft.subtitle,
        createdDate: draft.createdDate,
      );

      if (entity.title.isEmpty) {
        entity = entity.copyWith(title: 'untitled');
      }

      final draftIndex = _draftArticles.indexWhere((item) {
        return item.id == draft.id;
      });

      if (draftIndex == -1) {
        _draftArticles.add(entity);
      } else {
        _draftArticles[draftIndex] = entity;
      }

      final contents = draft.body.map((component) {
        return DraftArticleContent(
          content: component.text,
          order: component.order,
          draftArticleContentId: DraftArticleContent._id,
          draftArticleId: _lastId,
        );
      });

      _articleContents.removeWhere(
        (content) => content.draftArticleId == draft.id,
      );
      _articleContents.addAll(contents);

      final tags = draft.tags.map(
        (tag) => DraftArticleTag(draftArticleId: _lastId, tagId: tag.name),
      );
      _draftArticleTags.removeWhere((tag) => tag.draftArticleId == draft.id);
      _draftArticleTags.addAll(tags);

      final newHistory = DraftArticleHistory(
        draftArticleId: _lastId,
        updatedDate: DateTime.now().millisecondsSinceEpoch,
      );
      _draftArticleHistories.add(newHistory);

      return _lastId;
    } catch (ex) {
      _lastId--;
      rethrow;
    }
  }

  Future<List<DraftArticle>> fetchAllDraftsByUserId(int userId) async {
    return _draftArticles.where((draft) => draft.userId == userId).map((draft) {
      final components =
          _articleContents
              .where((component) => component.draftArticleId == draft.id)
              .map(
                (component) => BodyComponent(
                  text: component.content,
                  order: component.order,
                ),
              )
              .toList();

      final tags =
          _draftArticleTags
              .where((tag) => tag.draftArticleId == draft.id)
              .map((tag) => Tag(tag.tagId))
              .toList();

      final lastUpdatedDate =
          _draftArticleHistories
              .where((history) => history.draftArticleId == draft.id)
              .reduce((a, b) => a.updatedDate > b.updatedDate ? a : b)
              .updatedDate;

      return DraftArticle(
        id: draft.id,
        authorId: draft.userId,
        title: draft.title,
        subtitle: draft.subtitle,
        body: components,
        tags: tags,
        createdDate: draft.createdDate,
        lastUpdatedDate: lastUpdatedDate,
      );
    }).toList();
  }

  Future<DraftArticle?> fetchById(int draftId) async {
    try {
      final draft = _draftArticles.firstWhere(
        (draft) => draft.id == draftId,
        orElse: () => throw ArticleNotFoundException(),
      );

      final components =
          _articleContents
              .where((component) => component.draftArticleId == draft.id)
              .map(
                (component) => BodyComponent(
                  text: component.content,
                  order: component.order,
                ),
              )
              .toList();

      final tags =
          _draftArticleTags
              .where((tag) => tag.draftArticleId == draft.id)
              .map((tag) => Tag(tag.tagId))
              .toList();

      final lastUpdatedDate =
          _draftArticleHistories
              .where((history) => history.draftArticleId == draft.id)
              .reduce((a, b) => a.updatedDate > b.updatedDate ? a : b)
              .updatedDate;

      return DraftArticle(
        id: draft.id,
        authorId: draft.userId,
        title: draft.title,
        subtitle: draft.subtitle,
        body: components,
        tags: tags,
        createdDate: draft.createdDate,
        lastUpdatedDate: lastUpdatedDate,
      );
    } catch (ex) {
      return null;
    }
  }
}

final class DraftArticleContent {
  final int draftArticleContentId;
  final int draftArticleId;
  final int order;
  final String content;

  const DraftArticleContent({
    required this.draftArticleContentId,
    required this.draftArticleId,
    required this.order,
    required this.content,
  });

  static int _currentId = 0;

  static int get _id => _currentId++;
}

final class DraftArticleDataEntity {
  final int id;
  final int userId;
  final String title;
  final String subtitle;
  final int createdDate;

  const DraftArticleDataEntity({
    required this.id,
    required this.userId,
    required this.title,
    required this.subtitle,
    required this.createdDate,
  });

  DraftArticleDataEntity copyWith({
    int? id,
    int? userId,
    String? title,
    String? subtitle,
    int? createdDate,
  }) {
    return DraftArticleDataEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      createdDate: createdDate ?? this.createdDate,
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
