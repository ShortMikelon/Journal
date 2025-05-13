import 'package:flutter/material.dart';

import '../../common/event.dart';
import '../../data/tag/tag_repository.dart';
import '../../di/data_di.dart';

final class UserPreferencesProvider extends ChangeNotifier {
  final _tagRepository = DataDi().tagRepository;
  final _accountRepoistory = DataDi().accountRepository;

  final _tags = <Tag>[];
  final _selectedTags = <Tag>[];

  bool _isLoading = true;
  bool _isSubmitting = false;

  List<Tag> get tags => _tags;

  List<Tag> get selectedTags => _selectedTags;

  bool get isLoading => _isLoading;
  bool get isSubmitting => _isSubmitting;

  Event<String>? _errorEvent;
  Event<String>? get errorEvent => _errorEvent;

  Event<bool>? _loadingErrorEvent;
  Event<bool>? get loadingErrorEvent => _loadingErrorEvent;

  Event<bool>? _navigateToHome;
  Event<bool>? get navigateToHome => _navigateToHome;

  UserPreferencesProvider() {
    fetchTags();
  }

  void fetchTags() async {
    try {
      _isLoading = true;
      notifyListeners();

      final result = await _tagRepository.getAllTags();

      _tags.addAll(result);
    } catch (e) {
      _loadingErrorEvent = Event(false);
    } finally {
      _isLoading = false;

      notifyListeners();
    }
  }

  void selectTag(Tag tag) {
    if (!_selectedTags.contains(tag)) {
      _selectedTags.add(tag);
    } else {
      _selectedTags.remove(tag);
    }
    notifyListeners();
  }

  void submit() async {
    try {
      _isSubmitting = true;
      notifyListeners();

      await _accountRepoistory.editUserPreferences(selectedTags);
      _navigateToHome = Event(true);
    } catch (e) {
      _errorEvent = Event(e.toString());
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }
}
