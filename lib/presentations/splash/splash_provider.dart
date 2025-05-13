import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:journal/di/domain_di.dart';

import '../../common/event.dart';
import '../../di/data_di.dart';

class SplashProvider with ChangeNotifier {
  final _accountRepository = DataDi().accountRepository;

  late final AnimationController _controller;
  late final Animation<double> _animation;

  AnimationController get controller => _controller;
  Animation<double> get animation => _animation;

  Event<bool>? _isSignInEvent = null;

  Event<bool>? get isSignInEvent => _isSignInEvent;

  void _signInCheck() async {
    try {
      log('_signInCheck called');
      final isSignIn = await _accountRepository.isSignIn();

      _isSignInEvent = Event(isSignIn);

      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
      _signInCheck();
    }
  }

  void init(TickerProvider vsync) {
    log('init called');
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: vsync,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _controller.forward();

    _signInCheck();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
} 