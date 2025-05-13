import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:journal/data/articles/articles_repository.dart';
import 'package:journal/data/users/users_repository.dart';
import 'package:journal/domain/articles/entities/draft_article.dart';
import 'package:journal/domain/users/users_settings.dart';
import 'package:journal/presentations/article/details/entities/ui_comment.dart';

class ArticleDetailsEntity {
  final int id;
  final String title;
  final String? imageUrl;
  final List<ArticleAuthors> authors;
  final String date;
  final int readTime;
  final List<BodyComponent> content;
  final List<String> tags;
  final List<UiComment> comments;
  final int likes;
  final bool isLiked;
  final String currentUsername;
  final Uint8List? currentUserAvatarBytes;
  final bool isCurrentUserAuthor;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ArticleDetailsEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          imageUrl == other.imageUrl &&
          authors == other.authors &&
          date == other.date &&
          readTime == other.readTime &&
          content == other.content &&
          tags == other.tags &&
          comments == other.comments &&
          likes == other.likes &&
          isLiked == other.isLiked &&
          currentUsername == other.currentUsername &&
          currentUserAvatarBytes == other.currentUserAvatarBytes &&
          isCurrentUserAuthor == other.isCurrentUserAuthor;

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      imageUrl.hashCode ^
      authors.hashCode ^
      date.hashCode ^
      readTime.hashCode ^
      content.hashCode ^
      tags.hashCode ^
      comments.hashCode ^
      likes.hashCode ^
      isLiked.hashCode ^
      currentUsername.hashCode ^
      currentUserAvatarBytes.hashCode ^
      isCurrentUserAuthor.hashCode;

  const ArticleDetailsEntity({
    required this.id,
    required this.title,
    this.imageUrl,
    required this.authors,
    required this.date,
    required this.readTime,
    required this.content,
    required this.tags,
    required this.comments,
    required this.likes,
    required this.isLiked,
    required this.currentUsername,
    this.currentUserAvatarBytes,
    required this.isCurrentUserAuthor,
  });

  ArticleDetailsEntity copyWith({
    int? id,
    String? title,
    String? imageUrl,
    List<ArticleAuthors>? authors,
    String? date,
    int? readTime,
    List<BodyComponent>? content,
    List<String>? tags,
    List<UiComment>? comments,
    int? likes,
    bool? isLiked,
    String? currentUsername,
    Uint8List? currentUserAvatarBytes,
    bool? isCurrentUserAuthor,
  }) {
    return ArticleDetailsEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      imageUrl: imageUrl ?? this.imageUrl,
      authors: authors ?? this.authors,
      date: date ?? this.date,
      readTime: readTime ?? this.readTime,
      content: content ?? this.content,
      tags: tags ?? this.tags,
      comments: comments ?? this.comments,
      likes: likes ?? this.likes,
      isLiked: isLiked ?? this.isLiked,
      currentUsername: currentUsername ?? this.currentUsername,
      currentUserAvatarBytes:
          currentUserAvatarBytes ?? this.currentUserAvatarBytes,
      isCurrentUserAuthor: isCurrentUserAuthor ?? this.isCurrentUserAuthor,
    );
  }
}

final class ArticleAuthors {
  final int authorId;
  final String author;
  final String authorDescription;
  final Uint8List? authorAvatarUrl;
  final int followers;
  final bool isFollowed;

  const ArticleAuthors({
    required this.authorId,
    required this.author,
    required this.authorDescription,
    this.authorAvatarUrl,
    required this.followers,
    required this.isFollowed,
  });

  ArticleAuthors copyWith({
    int? authorId,
    String? author,
    String? authorDescription,
    Uint8List? authorAvatarUrl,
    int? followers,
    bool? isFollowed,
  }) {
    return ArticleAuthors(
      authorId: authorId ?? this.authorId,
      author: author ?? this.author,
      authorDescription: authorDescription ?? this.authorDescription,
      authorAvatarUrl: authorAvatarUrl ?? this.authorAvatarUrl,
      followers: followers ?? this.followers,
      isFollowed: isFollowed ?? this.isFollowed,
    );
  }
}

class ArticleDetailsProvider with ChangeNotifier {
  final ArticlesRepository _articlesRepository;
  final UsersRepository _usersRepository;
  final UserSettings _userSettings;

  ArticlesListState _state = LoadingState();

  ArticlesListState get state => _state;

  ArticleDetailsProvider({
    required ArticlesRepository articlesRepository,
    required UsersRepository usersRepository,
    required UserSettings userSettings,
  }) : _articlesRepository = articlesRepository,
       _usersRepository = usersRepository,
       _userSettings = userSettings;

  Future<void> fetchArticle(int articleId) async {
    try {
      final articleDetails = await _articlesRepository.getArticleById(
        articleId,
      );

      _state = SuccessState(articleDetails);
    } catch (e, stackTrace) {
      log(e.toString());
      log(stackTrace.toString());
      _state = ErrorState("Failed to load article");
    }
    notifyListeners();
  }

  Future<void> followOnPressed(ArticleAuthors author) async {
    if (_state is! SuccessState) return;

    final currentState = _state as SuccessState;
    final article = currentState.article;

    try {
      final id = await _userSettings.id;
      await _usersRepository.toggleFollow(
        authorId: author.authorId,
        userId: id!,
      );

      article.authors.add(
        author.copyWith(
          followers:
              author.isFollowed ? author.followers - 1 : author.followers + 1,
          isFollowed: !author.isFollowed,
        ),
      );

      _state = SuccessState(article.copyWith(authors: [...article.authors]));
      notifyListeners();
    } catch (e) {
      // Handle error if needed
    }
  }

  Future<void> likeOnPressed() async {
    if (_state is! SuccessState) return;

    final currentState = _state as SuccessState;
    final article = currentState.article;

    try {
      await _articlesRepository.likeArticle(article.id);

      _state = SuccessState(
        article.copyWith(
          likes: article.isLiked ? article.likes - 1 : article.likes + 1,
          isLiked: !article.isLiked,
        ),
      );
      notifyListeners();
    } catch (e) {
      // Handle error if needed
    }
  }

  Future<void> commentLikeOnPressed() async {
    // TODO: Implement comment like logic
  }

  Future<void> bookmarkOnPressed() async {
    // TODO: Implement bookmarks logic
  }
}

sealed class ArticlesListState {}

final class LoadingState extends ArticlesListState {}

final class SuccessState extends ArticlesListState {
  final ArticleDetailsEntity article;

  SuccessState(this.article);
}

final class ErrorState extends ArticlesListState {
  final String message;

  ErrorState(this.message);
}
