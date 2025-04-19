import 'package:flutter/material.dart';
import 'package:journal/data/articles/draft/draft_articles_repository.dart';
import 'package:journal/domain/articles/entities/draft_article.dart';
import 'package:journal/domain/users/users_settings.dart';

final class ArticleCreateParameterProvider with ChangeNotifier {
  final DraftArticlesRepository _draftArticlesRepository;
  final UserSettings _userSettings;
  final int _draftArticleId;

  late final DraftArticle? draftArticle;

  final titleController = TextEditingController();
  final subtitleController = TextEditingController();
  final List<String> selectedTopics = [];

  String get username => _userSettings.username;
  String? get avatarUrl => _userSettings.avatarUrl;

  ArticleCreateParameterProvider({
    required DraftArticlesRepository draftArticlesRepository,
    required UserSettings userSettings,
    required int draftArticleId,
  }) : _draftArticlesRepository = draftArticlesRepository,
       _userSettings = userSettings,
       _draftArticleId = draftArticleId {
    _fetchDraftById();
  }

  void addTopic(String topic) {
    if (!selectedTopics.contains(topic)) {
      selectedTopics.add(topic);
      notifyListeners();
    }
  }

  void removeTopic(String topic) {
    selectedTopics.remove(topic);
    notifyListeners();
  }

  void publishArticle() {
    // TODO: Implement publishing logic
  }

  void _fetchDraftById() async {
    draftArticle = await _draftArticlesRepository.fetchById(_draftArticleId);

    if (draftArticle != null) {
      titleController.text = draftArticle!.title;
      subtitleController.text = draftArticle!.subtitle;
      selectedTopics.addAll(draftArticle!.tags.map((tag) => tag.name));
      notifyListeners();
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    subtitleController.dispose();
    super.dispose();
  }
} 