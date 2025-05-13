import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:journal/common/event.dart';
import 'package:journal/data/articles/draft/draft_articles_repository.dart';
import 'package:journal/domain/articles/entities/draft_article.dart';
import 'package:journal/domain/users/users_settings.dart';
import 'package:journal/presentations/article/create/sandbox/ui_body_component.dart';
import 'package:journal/presentations/article/details/article_details_provider.dart';

final class ArticleCreateSandboxProvider with ChangeNotifier {
  final DraftArticlesRepository _draftArticlesRepository;

  final ImagePicker _picker = ImagePicker();

  DraftArticle? draftArticle;

  final titleController = TextEditingController();
  var bodyComponents = <UiBodyComponent>[
    UiTextBodyComponent(
      order: 1,
      controller: TextEditingController(),
      focusNode: FocusNode(),
    ),
  ];

  Event<String>? showSnackBarEvent;
  Event<int>? navigateToParametersEvent;
  Event<bool>? showLoadingEvent;

  int? _draftId;

  ArticleCreateSandboxProvider({
    required DraftArticlesRepository draftArticlesRepository,
    required UserSettings userSettings,
  }) : _draftArticlesRepository = draftArticlesRepository;

  void initialize(int draftArticleId) {
    _fetchDraftById(draftArticleId);
  }

  void handleTextChange(int order, String text) {
    if (text.isEmpty && bodyComponents.length > 1) {
      removeComponentByOrder(order);
      return;
    }

    if (text.endsWith('\n') && text.trim().isNotEmpty) {
      addNewTextField();
    }
  }

  void navigateToParameters() async {
    if (titleController.text.trim().isEmpty &&
        bodyComponents.every((component) {
          if (component is UiTextBodyComponent) {
            return component.controller.text.trim().isEmpty;
          }

          return true;
        })) {
      showSnackBarEvent = Event('Заполните заголовок и текст статьи');
      notifyListeners();
      return;
    }

    try {
      final id = await saveDraft();

      navigateToParametersEvent = Event(id);
    } catch (e) {
      showSnackBarEvent = Event('Error');
    } finally {
      notifyListeners();
    }
  }

  Future<int> saveDraft() async {
    try {
      if (draftArticle == null) {
        log('create new article');
        final draft = DraftArticle(
          tags: [],
          subtitle: '',
          title: titleController.text.trim(),
          id: 0,
          lastUpdatedDate: DateTime.now().millisecondsSinceEpoch,
          createdDate: DateTime.now().millisecondsSinceEpoch,
          body: bodyComponents.map(_mapUiComponentToDomain).toList(),
          authors: [ArticleAuthors(authorId: 1, author: 'author', authorDescription: 'authorDescription', followers: 0, isFollowed: false)]
        );

        return await _draftArticlesRepository.createDraft(draft);
      }

      log('saved article');
      final draft = DraftArticle(
        id: draftArticle?.id ?? _draftId ?? -1,
        authors: [ArticleAuthors(authorId: 1, isFollowed: false, followers: 0, authorDescription: '',author: '', authorAvatarUrl: null)],
        title: titleController.text.trim(),
        subtitle: draftArticle?.subtitle ?? '',
        tags: draftArticle?.tags ?? [],
        body:
            bodyComponents
                .where((component) {
                  return component is! UiTextBodyComponent ||
                      (component).controller.text.isNotEmpty;
                })
                .map(_mapUiComponentToDomain)
                .toList(),
        createdDate:
            draftArticle?.createdDate ?? DateTime.now().millisecondsSinceEpoch,
        lastUpdatedDate:
            draftArticle?.lastUpdatedDate ??
            DateTime.now().millisecondsSinceEpoch,
      );

      return _draftId = await _draftArticlesRepository.saveDraft(draft);
    } catch (ex, stackTrace) {
      log(ex.toString(), stackTrace: stackTrace);
      showSnackBarEvent = Event('Ошибка при сохранении черновика');
      throw SaveFailedException();
    }
  }

  Future<void> fixText() async {
    try {
      showLoadingEvent = Event(true);
      notifyListeners();

      _removeEmptyTextComponents();

      final result = await _draftArticlesRepository.fixText(
        bodyComponents.map(_mapUiComponentToDomain).toList(),
      );

      bodyComponents = result.map(_mapDomainComponentToUi).toList();
    } catch (e) {
      showSnackBarEvent = Event('Ошибка при исправлении текста: $e');
    } finally {
      showLoadingEvent = Event(false);
      notifyListeners();
    }
  }

  void removeComponentByOrder(int order) {
    final component = bodyComponents.firstWhere((c) => c.order == order);
    component.dispose();
    bodyComponents.remove(component);

    if (bodyComponents.isEmpty) {
      bodyComponents.add(
        UiTextBodyComponent(
          order: 1,
          controller: TextEditingController(),
          focusNode: FocusNode(),
        ),
      );
    }

    _updateOrder();
  }

  void addNewTextField() {
    final lastComponent = bodyComponents.last;
    if (lastComponent is UiTextBodyComponent &&
        lastComponent.controller.text.trim().isEmpty) {
      return;
    }

    final lastOrder =
        bodyComponents.reduce((a, b) => a.order > b.order ? a : b).order;
    final focusNode = FocusNode()..requestFocus();

    bodyComponents.add(
      UiTextBodyComponent(
        order: lastOrder + 1,
        controller: TextEditingController(),
        focusNode: focusNode,
      ),
    );

    notifyListeners();
  }

  void addNewImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
      );

      if (pickedFile != null) {
        final imageBytes = await pickedFile.readAsBytes();

        final lastOrder =
            bodyComponents.isNotEmpty ? bodyComponents.last.order : 0;

        bodyComponents.add(
          UiImageBodyComponent(
            order: lastOrder + 1,
            descriptionController: TextEditingController(),
            imageBytes: imageBytes,
          ),
        );

        notifyListeners();
      }
    } catch (e) {
      log(e.toString());
    }
  }

  void addNewGraph(UiChartBodyComponent component) {
    final lastOrder =
        bodyComponents.reduce((a, b) => a.order > b.order ? a : b).order;

    bodyComponents.add(component.copyWith(order: lastOrder));

    notifyListeners();
  }

  void addCode() {
    final lastComponent = bodyComponents.last;
    if (lastComponent is UiTextBodyComponent &&
        lastComponent.controller.text.trim().isEmpty) {
      bodyComponents.remove(lastComponent);
    }

    final lastOrder = bodyComponents.isNotEmpty ? bodyComponents.last.order : 0;

    final newComponent = UiCodeBodyComponent(order: lastOrder + 1, controller: TextEditingController());

    bodyComponents.add(newComponent);

    notifyListeners();
  }

  void handleCodeChange(String text, TextEditingController controller) {
      final cursorPos = controller.selection.baseOffset;
      if (cursorPos <= 0 || text.isEmpty) return;

      final char = text[cursorPos - 1];
      final closeMap = {
        '(': ')',
        '{': '}',
        '[': ']',
        '"': '"',
        "'": "'",
      };

      if (closeMap.containsKey(char)) {
        final result = _insertClosingChar(text, cursorPos, closeMap[char]!);
        controller.text = result.text;
        controller.selection = TextSelection.collapsed(offset: result.offset);
        notifyListeners();
        return;
      }

      if (char == '\n') {
        final result = _insertAutoIndent(text, cursorPos);
        controller.text = result.text;
        controller.selection = TextSelection.collapsed(offset: result.offset);
      } else if (char == '\t') {
        final result = _insertTab(text, cursorPos);
        controller.text = result.text;
        controller.selection = TextSelection.collapsed(offset: result.offset);
      } else if (char == '}') {
        final result = _autoUnindent(text, cursorPos);
        controller.text = result.text;
        controller.selection = TextSelection.collapsed(offset: result.offset);
      }

      notifyListeners();
    }
    ({String text, int offset}) _insertAutoIndent(String text, int cursorPos) {
    final lineStart = text.lastIndexOf('\n', cursorPos - 2) + 1;
    final currentLine = text.substring(lineStart, cursorPos - 1);
    final indentMatch = RegExp(r'^\s*').firstMatch(currentLine);
    final currentIndent = indentMatch?.group(0) ?? '';
    final shouldIncrease = currentLine.trim().endsWith('{');

    final newIndent = '\n$currentIndent${shouldIncrease ? '  ' : ''}';
    final updated = text.replaceRange(cursorPos - 1, cursorPos, newIndent);
    final offset = cursorPos - 1 + newIndent.length;
    return (text: updated, offset: offset);
  }

  ({String text, int offset}) _insertTab(String text, int cursorPos) {
    final updated = text.replaceRange(cursorPos - 1, cursorPos, '  ');
    return (text: updated, offset: cursorPos + 1);
  }

  ({String text, int offset}) _autoUnindent(String text, int cursorPos) {
    final lineStart = text.lastIndexOf('\n', cursorPos - 2) + 1;
    final before = text.substring(lineStart, cursorPos);

    final indentMatch = RegExp(r'^\s+').firstMatch(before);
    if (indentMatch == null) return (text: text, offset: cursorPos);

    final indent = indentMatch.group(0)!;
    if (indent.length < 2) return (text: text, offset: cursorPos);

    final newIndent = indent.substring(0, indent.length - 2);
    final updated = text.replaceRange(lineStart, lineStart + indent.length, newIndent);
    final offset = cursorPos - 2;

    return (text: updated, offset: offset);
  }

  ({String text, int offset}) _insertClosingChar(String text, int cursorPos, String closingChar) {
    final newText = text.substring(0, cursorPos) + closingChar + text.substring(cursorPos);
    final newOffset = cursorPos;
    return (text: newText, offset: newOffset);
  }

  void formatCode(UiCodeBodyComponent component) {
    final controller = component.controller;
    final lines = controller.text.split('\n');
    final formatted = <String>[];
    int indentLevel = 0;

    for (var line in lines) {
      final trimmed = line.trim();

      if (trimmed.isEmpty) {
        formatted.add('');
        continue;
      }

      if (trimmed.startsWith('}')) indentLevel--;

      final indent = '  ' * indentLevel;
      formatted.add('$indent$trimmed');

      if (trimmed.endsWith('{')) indentLevel++;
    }

    controller.text = formatted.join('\n');
    notifyListeners();
  }

  @override
  void dispose() {
    titleController.dispose();
    for (final component in bodyComponents) {
      component.dispose();
    }
    super.dispose();
  }

  void _fetchDraftById(int draftId) async {
    if (draftId == -1) return;

    draftArticle = await _draftArticlesRepository.fetchById(draftId);

    if (draftArticle != null) {
      titleController.text = draftArticle!.title;

      bodyComponents.clear();
      bodyComponents.addAll(draftArticle!.body.map(_mapDomainComponentToUi));

      notifyListeners();
    }
  }

  UiBodyComponent _mapDomainComponentToUi(BodyComponent component) {
    switch (component) {
      case TextBodyComponent():
        return UiTextBodyComponent(
          order: component.order,
          controller: TextEditingController(text: component.text),
          focusNode: FocusNode(),
        );
      case ImageBodyComponent():
        return UiImageBodyComponent(
          order: component.order,
          descriptionController: TextEditingController(
            text: component.description,
          ),
          imageBytes: component.imageBytes,
        );
      case ChartBodyComponent(
        order: final order,
        points: final points,
        title: final title,
        chartType: final type,
      ):
        final _points =
            points
                .map(
                  (point) => UiChartPoint(
                    x: point.x,
                    labelController: TextEditingController(text: point.label),
                    y: point.y,
                    color: point.color,
                  ),
                )
                .toList();

        return UiChartBodyComponent(
          order: order,
          points: _points,
          title: title,
          type: type,
        );
    }
  }

  BodyComponent _mapUiComponentToDomain(UiBodyComponent component) {
    switch (component) {
      case UiTextBodyComponent():
        return TextBodyComponent(
          text: component.controller.text.trim(),
          order: component.order,
        );
      case UiImageBodyComponent():
        return ImageBodyComponent(
          order: component.order,
          description: component.descriptionController.text,
          imageBytes: component.imageBytes,
        );
      case UiChartBodyComponent():
        return ChartBodyComponent(
          order: component.order,
          points:
              component.points
                  .map(
                    (point) => ChartPoint(
                      color: point.color,
                      label: point.labelController.text.trim(),
                      x: point.x,
                      y: point.y,
                    ),
                  )
                  .toList(),
          title: component.title,
          chartType: component.type,
        );
      case UiCodeBodyComponent():
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }

  void _removeEmptyTextComponents() {
    bodyComponents.removeWhere((component) {
      return component is UiTextBodyComponent &&
          (component).controller.text.trim().isEmpty;
    });

    for (int i = 0; i < bodyComponents.length; i++) {
      final component = bodyComponents[i];

      switch (component) {
        case UiTextBodyComponent():
          bodyComponents[i] = UiTextBodyComponent(
            order: i + 1,
            controller: component.controller,
            focusNode: component.focusNode,
          );
          break;
        case UiImageBodyComponent():
          bodyComponents[i] = UiImageBodyComponent(
            order: i + 1,
            descriptionController: component.descriptionController,
            imageBytes: component.imageBytes,
          );
          break;
        case UiChartBodyComponent():
          bodyComponents[i] = UiChartBodyComponent(
            order: i + 1,
            points: component.points,
            title: component.title,
            type: component.type,
          );
        case UiCodeBodyComponent():
          // TODO: Handle this case.
          throw UnimplementedError();
      }
    }
  }

  void _updateOrder() {
    for (int i = 0; i < bodyComponents.length; i++) {
      final component2 = bodyComponents[i];

      if (component2 is UiTextBodyComponent) {
        bodyComponents[i] = UiTextBodyComponent(
          order: i + 1,
          controller: component2.controller,
          focusNode: component2.focusNode,
        );
      } else if (component2 is UiImageBodyComponent) {
        bodyComponents[i] = UiImageBodyComponent(
          order: i + 1,
          descriptionController: component2.descriptionController,
          imageBytes: component2.imageBytes,
        );
      }
    }

    notifyListeners();
  }

  static const saveErrorCode = -2;
}

final class SaveFailedException implements Exception {}
