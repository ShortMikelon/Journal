import 'package:flutter/material.dart';
import 'package:journal/data/articles/draft/draft_articles_repository.dart';
import 'package:journal/domain/articles/entities/draft_article.dart';
import 'package:journal/domain/users/users_settings.dart';

final class ArticleCreateSandboxProvider with ChangeNotifier {
  final DraftArticlesRepository _draftArticlesRepository;
  final UserSettings _userSettings;

  late final DraftArticle? draftArticle;

  final titleController = TextEditingController();
  final bodyComponents = <UiBodyComponent>[
    UiBodyComponent(
      order: 1,
      controller: TextEditingController(),
      focusNode: FocusNode(),
    ),
  ];

  Event<String>? showSnackBarEvent;
  Event<int>? navigateToParametersEvent;

  ArticleCreateSandboxProvider({
    required DraftArticlesRepository draftArticlesRepository,
    required UserSettings userSettings,
    required int draftArticleId,
  }) : _draftArticlesRepository = draftArticlesRepository,
       _userSettings = userSettings {
    _fetchDraftById(draftArticleId);
  }

  void addNewTextField() {
    final lastOrder =
        bodyComponents.reduce((a, b) => a.order > b.order ? a : b).order;
    bodyComponents.add(
      UiBodyComponent(
        order: lastOrder + 1,
        controller: TextEditingController(),
        focusNode: FocusNode()..requestFocus(),
      ),
    );

    notifyListeners();
  }

  void navigateToParameters() async {
    if (titleController.text.trim().isEmpty && 
        bodyComponents.every((component) => component.controller.text.trim().isEmpty)) {
      showSnackBarEvent = Event('Заполните заголовок и текст статьи');
      notifyListeners();
      return;
    }

    final id = await saveDraft();

    if (id == SAVE_ERROR_CODE) return;

    navigateToParametersEvent = Event(draftArticle?.id ?? -1);

    notifyListeners();
  }

   Future<int> saveDraft() async {
    try {
      final draft = DraftArticle(
        id: draftArticle?.id ?? -1,
        authorId: _userSettings.id,
        title: titleController.text.trim(),
        subtitle: draftArticle?.subtitle ?? '',
        tags: draftArticle?.tags ?? [],
        body:
            bodyComponents
                .map(
                  (component) => BodyComponent(
                    text: component.controller.text.trim(),
                    order: component.order,
                  ),
                )
                .toList(),
        createdDate:
            draftArticle?.createdDate ?? DateTime.now().millisecondsSinceEpoch,
        lastUpdatedDate:
            draftArticle?.lastUpdatedDate ??
            DateTime.now().millisecondsSinceEpoch,
      );

      return await _draftArticlesRepository.saveDraft(draft);
    } catch (ex) {
      showSnackBarEvent = Event('Ошибка при сохранении черновика');
      return -3;
    }
  }

  void _fetchDraftById(int draftId) async {
    draftArticle = await _draftArticlesRepository.fetchById(draftId);

    if (draftArticle != null) {
      titleController.text = draftArticle!.title;

      bodyComponents.clear();
      bodyComponents.addAll(
        draftArticle!.body.map(
          (component) => UiBodyComponent(
            order: component.order,
            controller: TextEditingController(text: component.text),
            focusNode: FocusNode(),
          ),
        ),
      );

      notifyListeners();
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    for (final component in bodyComponents) {
      component.controller.dispose();
      component.focusNode.dispose();
    }
    super.dispose();
  }

  static final SAVE_ERROR_CODE = -2;
}

final class UiBodyComponent {
  final int order;
  final TextEditingController controller;
  final FocusNode focusNode;

  const UiBodyComponent({
    required this.order,
    required this.controller,
    required this.focusNode,
  });
}

class Event<T> {
  T? _value;

  Event(T value) : _value = value;

  T? get value {
    if (_value == null) return null;

    final temp = _value;
    _value = null;

    return temp;
  }
}
