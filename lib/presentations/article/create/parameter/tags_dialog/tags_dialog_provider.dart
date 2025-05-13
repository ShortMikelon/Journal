import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:journal/data/tag/tag_repository.dart';

final class TagsDialogProvider with ChangeNotifier {
  final TagRepository _tagRepository;
  final List<Tag> _selectedTags;
  List<Tag> _allTags = [];
  bool _isLoading = true;
  String? _error;

  List<Tag> get allTags => _allTags;
  List<Tag> get selectedTags {
    log("selected tags length: ${_selectedTags.length}");
    return _selectedTags;
  }
  bool get isLoading => _isLoading;
  String? get error => _error;

  TagsDialogProvider({
    required TagRepository tagRepository,
    required List<Tag> selectedTags,
  }) : _tagRepository = tagRepository,
       _selectedTags = List.of(selectedTags) {
    _loadAllTags();
  }

  Future<void> _loadAllTags() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _allTags = await _tagRepository.getAllTags();
    } catch (e) {
      _error = 'Не удалось загрузить тэги';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void toggleTag(Tag tag) {
    if (_selectedTags.where((tag2) => tag2.name == tag.name).isNotEmpty) {
      log("tag removed");
      _selectedTags.removeWhere((tag2) => tag2.name == tag.name);
    } else {
      log('tag added');
      _selectedTags.add(tag);
    }

    notifyListeners();
  }
} 