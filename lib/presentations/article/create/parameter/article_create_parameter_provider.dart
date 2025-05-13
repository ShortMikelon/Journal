import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:journal/common/event.dart';
import 'package:journal/data/articles/articles_repository.dart';
import 'package:journal/data/articles/draft/draft_articles_repository.dart';
import 'package:journal/data/tag/tag_repository.dart';
import 'package:journal/domain/articles/entities/draft_article.dart';
import 'package:journal/domain/users/users_settings.dart';

final class ArticleCreateParameterProvider with ChangeNotifier {
  final DraftArticlesRepository _draftArticlesRepository;
  final ArticlesRepository _articlesRepository;
  final UserSettings _userSettings;
  final int _draftArticleId;
  final TagRepository _tagRepository;

  late final DraftArticle? draftArticle;

  Event<bool>? showLoadingEvent;
  Event<String>? showErrorEvent;
  Event<List<BodyComponent>>? textFixedEvent;
  Event<bool>? navigateToSandboxPageEvent;
  Event<bool>? publishEvent;

  final titleController = TextEditingController();
  final subtitleController = TextEditingController();
  final List<Tag> selectedTopics = [];
  List<Tag> _allTags = [];

  List<Tag> get allTags => _allTags;

  String _username = '';
  String get username => _username;

  Uint8List? _avatarBytes = null;
  Uint8List? get avatarBytes => _avatarBytes;

  ArticleCreateParameterProvider({
    required DraftArticlesRepository draftArticlesRepository,
    required ArticlesRepository articlesRepository,
    required UserSettings userSettings,
    required int draftArticleId,
    required TagRepository tagRepository,
  }) : _draftArticlesRepository = draftArticlesRepository,
       _articlesRepository = articlesRepository,
       _userSettings = userSettings,
       _draftArticleId = draftArticleId,
       _tagRepository = tagRepository {
    fetchDraftById();
    _loadAllTags();
  }


  Future<void> _loadAllTags() async {
    try {
      _allTags = await _tagRepository.getAllTags();
      notifyListeners();
    } catch (e) {
      showErrorEvent = Event('Не удалось загрузить тэги');
      notifyListeners();
    }
  }

  void toggleTopic(Tag topic) {
    log('toggle topic');
    if (selectedTopics.contains(topic)) {
      selectedTopics.remove(topic);
    } else {
      selectedTopics.add(topic);
    }
    notifyListeners();
  }

  void editOnPressed() async {
    await saveDraft();

    navigateToSandboxPageEvent = Event(true);
  }

  void fetchDraftById() async {
    try {

      showLoadingEvent = Event(true);
      notifyListeners();

      _username = (await _userSettings.username)!;
      _avatarBytes = await _userSettings.avatarBytes;

      draftArticle = await _draftArticlesRepository.fetchById(_draftArticleId);

      if (draftArticle != null) {
        titleController.text = draftArticle!.title;
        subtitleController.text = draftArticle!.subtitle;
        selectedTopics.addAll(draftArticle!.tags);
      }
    } catch (e) {
      showErrorEvent = Event('Не удалось загрузить данные');
    } finally {
      showLoadingEvent = Event(false);
      notifyListeners();
    }
  }

  Future<void> saveDraft() async {
    _draftArticlesRepository.saveDraft(DraftArticle(
      id: draftArticle!.id,
      authors: draftArticle!.authors,
      title: titleController.text.trim(),
      subtitle: subtitleController.text.trim(),
      body: draftArticle!.body,
      tags: selectedTopics,
      createdDate: draftArticle!.createdDate,
      lastUpdatedDate: DateTime.now().millisecondsSinceEpoch,
    ));
  }

  Future<void> publishArticle() async {
    _articlesRepository.publishArticle(_draftArticleId);
    _draftArticlesRepository.publish(_draftArticleId);

    publishEvent = Event(true);
    notifyListeners();
  }

  void tagOnSelected(Tag tag) {
    if (selectedTopics.where((item) => item.name == tag.name).isEmpty) {
      selectedTopics.add(tag);
    } else {
      selectedTopics.remove(tag);
    }
    notifyListeners();
  }

  @override
  void dispose() {
    titleController.dispose();
    subtitleController.dispose();
    super.dispose();
  }
} 