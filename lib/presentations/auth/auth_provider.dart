import 'package:flutter/material.dart';
import 'package:journal/data/api/user/login_request_dto.dart';

import '../../common/event.dart';
import '../../di/data_di.dart';

final class AuthProvider extends ChangeNotifier {
  final _accountRepository = DataDi().accountRepository;

  // Login Controllers
  final loginEmailCtrl = TextEditingController();
  final loginPasswordCtrl = TextEditingController();

  // Register Controllers
  final registerEmailCtrl = TextEditingController();
  final registerPasswordCtrl = TextEditingController();
  final registerRepeatPasswordCtrl = TextEditingController();
  final registerNameCtrl = TextEditingController();

  // UI state
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Event<String>? _errorEvent;
  Event<String>? get errorEvent => _errorEvent;

  Event<int>? _navigationEvent;
  Event<int>? get navigationEvent => _navigationEvent;

  // Validation errors
  String? loginEmailError;
  String? loginPasswordError;

  String? registerEmailError;
  String? registerPasswordError;
  String? registerRepeatPasswordError;
  String? registerNameError;

  AuthProvider() {
    _attachListeners();
  }

  void _attachListeners() {
    loginEmailCtrl.addListener(_clearLoginErrors);
    loginPasswordCtrl.addListener(_clearLoginErrors);

    registerEmailCtrl.addListener(_clearRegisterErrors);
    registerPasswordCtrl.addListener(_clearRegisterErrors);
    registerRepeatPasswordCtrl.addListener(_clearRegisterErrors);
    registerNameCtrl.addListener(_clearRegisterErrors);
  }

  void _clearLoginErrors() {
    if (loginEmailError != null || loginPasswordError != null) {
      loginEmailError = null;
      loginPasswordError = null;
      notifyListeners();
    }
  }

  void _clearRegisterErrors() {
    if (registerEmailError != null ||
        registerPasswordError != null ||
        registerRepeatPasswordError != null ||
        registerNameError != null) {
      registerEmailError = null;
      registerPasswordError = null;
      registerRepeatPasswordError = null;
      registerNameError = null;
      notifyListeners();
    }
  }

  Future<void> login(String? fcmToken) async {
    final email = loginEmailCtrl.text.trim();
    final password = loginPasswordCtrl.text.trim();

    bool hasError = false;

    if (email.isEmpty || !email.contains('@')) {
      loginEmailError = 'Некорректный email';
      hasError = true;
    }

    if (password.length < 6) {
      loginPasswordError = 'Минимум 6 символов';
      hasError = true;
    }

    if (hasError) {
      notifyListeners();
      return;
    }

    _setLoading(true);
    try {
      await _accountRepository.login(LoginRequestDto(email: email, password: password, fcmToken: fcmToken));
      _navigationEvent = Event(navigateToHome);
    } catch (e) {
      _errorEvent = Event('Ошибка входа: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> register(String? fcmToken) async {
    final email = registerEmailCtrl.text.trim();
    final password = registerPasswordCtrl.text.trim();
    final repeatPassword = registerRepeatPasswordCtrl.text.trim();
    final name = registerNameCtrl.text.trim();

    bool hasError = false;

    if (email.isEmpty || !email.contains('@')) {
      registerEmailError = 'Некорректный email';
      hasError = true;
    }

    if (name.isEmpty) {
      registerNameError = 'Имя обязательно';
      hasError = true;
    }

    if (password.length < 6) {
      registerPasswordError = 'Минимум 6 символов';
      hasError = true;
    }

    if (repeatPassword != password) {
      registerRepeatPasswordError = 'Пароли не совпадают';
      hasError = true;
    }

    if (hasError) {
      notifyListeners();
      return;
    }

    _setLoading(true);
    try {
      await _accountRepository.registration(
          email: email,
          name: name,
          password: password,
          fcmToken: fcmToken,
      );

      _navigationEvent = Event(navigateToUserPreferences);
    } catch (e) {
      _errorEvent = Event('Ошибка регистрации: $e');
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    if (_isLoading != value) {
      _isLoading = value;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    loginEmailCtrl.dispose();
    loginPasswordCtrl.dispose();
    registerEmailCtrl.dispose();
    registerPasswordCtrl.dispose();
    registerRepeatPasswordCtrl.dispose();
    registerNameCtrl.dispose();

    super.dispose();
  }

  static const navigateToHome = 1;
  static const navigateToUserPreferences = 2;

}
