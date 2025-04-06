part of 'articles_list_provider.dart';

sealed class ArticlesListState {}

final class LoadingState extends ArticlesListState {}

final class EmptyState extends ArticlesListState {}

final class SuccessState extends ArticlesListState {
  final List<ArticleListPreviewEntity> articles;
  final List<Tag> tags;

  SuccessState({required this.articles, required this.tags});
}

final class ErrorState extends ArticlesListState {
  final String message;

  ErrorState(this.message);
}

final class LoadingMoreState extends ArticlesListState {
  final List<ArticleListPreviewEntity> articles;
  final List<Tag> tags;
  final bool isLoading;

  LoadingMoreState({required this.articles, required this.tags, this.isLoading = true});
}

final class LoadingMoreErrorState extends ArticlesListState {
  final List<ArticleListPreviewEntity> articles;
  final List<Tag> tags;
  final String errorMessage;

  LoadingMoreErrorState({required this.articles, required this.errorMessage, required this.tags});
}

final class LoadingMoreEmptyState extends ArticlesListState {
  final List<ArticleListPreviewEntity> articles;
  final List<Tag> tags;

  LoadingMoreEmptyState({required this.articles, required this.tags});
}
