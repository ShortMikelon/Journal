import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:journal/data/articles/articles_repository.dart';
import 'package:journal/data/articles/draft/draft_articles_repository.dart';
import 'package:journal/data/users/users_repository.dart';
import 'package:journal/domain/articles/entities/article_list_preview.dart';
import 'package:journal/domain/articles/entities/draft_article.dart';
import 'package:journal/domain/users/users_settings.dart';
import 'package:journal/presentations/profile/profile_page.dart';

class ProfileProvider with ChangeNotifier {
  PostFilter selected = PostFilter.public;

  late List<ArticleListPreviewEntity> articles;
  late List<DraftArticle> drafts;
  late String username = '';
  late Uint8List? avatarBytes;
  late int followers;
  late int following;

  final UserSettings _userSettings;
  final ArticlesRepository _articlesRepository;
  final DraftArticlesRepository _draftArticlesRepository;
  final UsersRepository _usersRepository;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  ProfileProvider({
    required UserSettings userSettings,
    required ArticlesRepository articlesRepository,
    required DraftArticlesRepository draftArticlesRepository,
    required UsersRepository usersRepository,
  })  : _userSettings = userSettings,
        _articlesRepository = articlesRepository,
        _draftArticlesRepository = draftArticlesRepository,
        _usersRepository = usersRepository {
    _init();
  }

  Future<void> _init() async {
    try {
      final id = await _userSettings.id;

      final user = await _usersRepository.getUserDetails(id!);
      username = user.name;
      avatarBytes = user.avatarBytes;
      followers = user.followers;
      following = user.following;

      articles = await _articlesRepository.getArticlesByUserId(id);
      drafts = await _draftArticlesRepository.fetchAllDraftsByUserId(id);
    } catch (e, stackTrace) {
      log(e.toString(), stackTrace: stackTrace);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void postFilterOnChanged(PostFilter? newValue) {
    if (newValue == null) return;
    selected = newValue;

    notifyListeners();
  }
}

