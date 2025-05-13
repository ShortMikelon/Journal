import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:journal/di/presentation_di.dart';
import 'package:journal/presentations/routes.dart';
import 'package:journal/presentations/splash/splash_provider.dart';
import 'package:provider/provider.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PresentationDi().splashProvider,
      child: const _SplashContent(),
    );
  }
}

class _SplashContent extends StatefulWidget {
  const _SplashContent();

  @override
  State<_SplashContent> createState() => _SplashContentState();
}

class _SplashContentState extends State<_SplashContent> with SingleTickerProviderStateMixin {
  @override
  @override
  void initState() {
    super.initState();
    context.read<SplashProvider>().init(this);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SplashProvider>();
    final event = provider.isSignInEvent?.value;

    if (event != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(
          context,
          event ? Routes.home : Routes.auth,
        );
      });
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: FadeTransition(
          opacity: context.watch<SplashProvider>().animation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.article,
                size: 100,
                color: Theme.of(context).colorScheme.secondary,
              ),
              const SizedBox(height: 24),
              Text(
                'Journal',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 