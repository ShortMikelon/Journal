import 'package:flutter/material.dart';
import 'package:journal/data/articles/articles_repository.dart';
import 'package:journal/domain/articles/entities/article_list_preview.dart';

part 'articles_list_state.dart';

final class ArticlesListProvider with ChangeNotifier {
  final ArticlesRepository _articlesRepository;

  ArticlesListState _state = LoadingState();
  ArticlesListState get state => _state;

  final _limit = 10;
  var _page = 0;
  var _isLoading = false;
  var _hasMore = true;

  final _scrollController = ScrollController();
  ScrollController get scrollController => _scrollController;

  ArticlesListProvider({required ArticlesRepository articlesRepository})
      : _articlesRepository = articlesRepository {
    _scrollController.addListener(_onScroll);
    loadArticles();
  }

  Future<void> loadArticles() async {
    if (_isLoading) return;
    
    _isLoading = true;
    _page = 0;
    _hasMore = true;

    try {
      _state = LoadingState();
      notifyListeners();

      final tags = await _articlesRepository.getAllTags();
      final articles = await _articlesRepository.getAllArticles(
        page: _page,
        limit: _limit,
      );

      if (articles.isEmpty) {
        _state = EmptyState();
      } else {
        _state = SuccessState(articles: articles, tags: tags);
        _hasMore = articles.length == _limit;
      }
    } catch (e) {
      _state = ErrorState(e.toString());
    } finally {
      _isLoading = false;
      _page++;
      notifyListeners();
    }
  }

  Future<void> _loadMoreArticles() async {
    if (_isLoading || !_hasMore) return;
    if (_state is! SuccessState) return;

    _isLoading = true;
    final currentState = _state as SuccessState;

    try {
      _state = LoadingMoreState(
        articles: currentState.articles,
        tags: currentState.tags,
      );
      notifyListeners();

      final newArticles = await _articlesRepository.getAllArticles(
        page: _page,
        limit: _limit,
      );

      if (newArticles.isEmpty) {
        _hasMore = false;
        _state = LoadingMoreEmptyState(
          articles: currentState.articles,
          tags: currentState.tags,
        );
      } else {
        _hasMore = newArticles.length == _limit;
        _state = SuccessState(
          articles: [...currentState.articles, ...newArticles],
          tags: currentState.tags,
        );
        _page++;
      }
    } catch (e) {
      _state = LoadingMoreErrorState(
        articles: currentState.articles,
        tags: currentState.tags,
        errorMessage: e.toString(),
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      _loadMoreArticles();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }
}
