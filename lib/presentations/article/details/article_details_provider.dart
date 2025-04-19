import 'package:flutter/material.dart';
import 'package:journal/data/articles/articles_repository.dart';
import 'package:journal/domain/articles/entities/draft_article.dart';
import 'package:journal/presentations/article/details/entities/ui_comment.dart';

class ArticleDetailsEntity {
  final int id;
  final String title;
  final String? imageUrl;
  final int authorId;
  final String author;
  final String authorDescription;
  final String? authorAvatarUrl;
  final String date;
  final int readTime;
  final List<BodyComponent> content;
  final List<String> tags;
  final List<UiComment> comments;
  final int likes;
  final bool isLiked;
  final int followers;
  final bool isFollowed;
  final String currentUsername;
  final String? currentUserAvatarUrl;
  final bool isCurrentUserAuthor;

  const ArticleDetailsEntity({
    required this.id,
    required this.title,
    this.imageUrl,
    required this.authorId,
    required this.author,
    required this.authorDescription,
    this.authorAvatarUrl,
    required this.date,
    required this.readTime,
    required this.content,
    required this.tags,
    required this.comments,
    required this.likes,
    required this.isLiked,
    required this.followers,
    required this.isFollowed,
    required this.currentUsername,
    this.currentUserAvatarUrl,
    required this.isCurrentUserAuthor,
  });

  ArticleDetailsEntity copyWith({
    int? id,
    String? title,
    String? imageUrl,
    int? authorId,
    String? author,
    String? authorDescription,
    String? authorAvatarUrl,
    String? date,
    int? readTime,
    List<BodyComponent>? content,
    List<String>? tags,
    List<UiComment>? comments,
    int? likes,
    bool? isLiked,
    int? followers,
    bool? isFollow,
    String? currentUsername,
    String? currentUserAvatarUrl,
    bool? isCurrentUserAuthor,
  }) {
    return ArticleDetailsEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      imageUrl: imageUrl ?? this.imageUrl,
      authorId: authorId ?? this.authorId,
      author: author ?? this.author,
      authorDescription: authorDescription ?? this.authorDescription,
      authorAvatarUrl: authorAvatarUrl ?? this.authorAvatarUrl,
      date: date ?? this.date,
      readTime: readTime ?? this.readTime,
      content: content ?? this.content,
      tags: tags ?? this.tags,
      comments: comments ?? this.comments,
      likes: likes ?? this.likes,
      isLiked: isLiked ?? this.isLiked,
      followers: followers ?? this.followers,
      isFollowed: isFollow ?? isFollowed,
      currentUsername: currentUsername ?? this.currentUsername,
      currentUserAvatarUrl: currentUserAvatarUrl ?? this.currentUserAvatarUrl,
      isCurrentUserAuthor: isCurrentUserAuthor ?? this.isCurrentUserAuthor,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ArticleDetailsEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          imageUrl == other.imageUrl &&
          authorId == other.authorId &&
          author == other.author &&
          authorDescription == other.authorDescription &&
          authorAvatarUrl == other.authorAvatarUrl &&
          date == other.date &&
          readTime == other.readTime &&
          content == other.content &&
          tags == other.tags &&
          comments == other.comments &&
          likes == other.likes &&
          isLiked == other.isLiked &&
          followers == other.followers &&
          isFollowed == other.isFollowed &&
          currentUsername == other.currentUsername &&
          currentUserAvatarUrl == other.currentUserAvatarUrl &&
          isCurrentUserAuthor == other.isCurrentUserAuthor;

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      imageUrl.hashCode ^
      authorId.hashCode ^
      author.hashCode ^
      authorDescription.hashCode ^
      authorAvatarUrl.hashCode ^
      date.hashCode ^
      readTime.hashCode ^
      content.hashCode ^
      tags.hashCode ^
      comments.hashCode ^
      likes.hashCode ^
      isLiked.hashCode ^
      followers.hashCode ^
      isFollowed.hashCode ^
      currentUsername.hashCode ^
      currentUserAvatarUrl.hashCode ^
      isCurrentUserAuthor.hashCode;
}

class ArticleDetailsProvider with ChangeNotifier {
  final ArticlesRepository _articlesRepository;

  ArticlesListState _state = LoadingState();

  ArticlesListState get state => _state;

  ArticleDetailsProvider({
    required ArticlesRepository articlesRepository,
  }) : _articlesRepository = articlesRepository;

  Future<void> fetchArticle(int articleId) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      final articleDetails = await _articlesRepository.getArticleById(articleId);

      _state = SuccessState(articleDetails);
    } catch (e) {
      _state = ErrorState("Failed to load article");
    }
    notifyListeners();
  }

  Future<void> followOnPressed() async {
    if (_state is! SuccessState) return;
    
    final currentState = _state as SuccessState;
    final article = currentState.article;
    
    try {
      await _articlesRepository.toggleFollow(article.authorId);
      
      _state = SuccessState(
        article.copyWith(
          followers: article.isFollowed ? article.followers - 1 : article.followers + 1,
          isFollow: !article.isFollowed,
        ),
      );
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
    // TODO: Implement bookmark logic
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


