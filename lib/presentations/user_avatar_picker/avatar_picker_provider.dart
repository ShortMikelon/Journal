import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:journal/common/event.dart';
import 'package:journal/di/data_di.dart';

final class AvatarPickerProvider extends ChangeNotifier {
  final _accountRepository = DataDi().accountRepository;

  File? _selectedImage;
  bool _isLoading = false;

  File? get selectedImage => _selectedImage;
  bool get isLoading => _isLoading;

  Event<bool>? _navigateToNextPage;
  Event<bool>? get navigateToNextPageEvent => _navigateToNextPage;

  Event<String>? _errorEvent;
  Event<String>? get errorEvent => _errorEvent;

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      _selectedImage = File(pickedFile.path);
      notifyListeners();
    }
  }

  void clearImage() {
    _selectedImage = null;
    notifyListeners();
  }

  Future<void> submit(BuildContext context) async {
    if (_isLoading) return;
    _isLoading = true;
    notifyListeners();

    try {
      if (selectedImage != null) {
        final avatarBytes = await _selectedImage!.readAsBytes();
        _accountRepository.editAvatar(avatarBytes);
      }

      _navigateToNextPage = Event(true);
    } catch (e) {
      _errorEvent = Event('Ошибка: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
