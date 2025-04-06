import 'package:flutter/material.dart';

class SplashProvider with ChangeNotifier {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  AnimationController get controller => _controller;
  Animation<double> get animation => _animation;

  void init(TickerProvider vsync) {
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: vsync,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _controller.forward();
  }

  void dispose() {
    _controller.dispose();
  }
} 