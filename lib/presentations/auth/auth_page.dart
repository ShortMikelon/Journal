import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:journal/presentations/routes.dart';
import 'package:provider/provider.dart';
import 'auth_provider.dart';

final class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            toolbarHeight: 100,
            title: Text(
              'Добро пожаловать',
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            bottom: TabBar(
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(color: Colors.black, width: 3),
                ),
              ),
              labelStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              unselectedLabelStyle: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(fontSize: 18),
              tabs: [Tab(child: Text('Вход')), Tab(child: Text('Регистрация'))],
            ),
          ),
          body: const TabBarView(children: [LoginForm(), RegisterForm()]),
        ),
      ),
    );
  }
}

final class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AuthProvider>();

    final error = provider.errorEvent?.value;
    if (error != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(error)));
        }
      });
    }

    final navigation = provider.navigationEvent?.value;
    if (navigation != null && navigation == AuthProvider.navigateToHome) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          Navigator.pushReplacementNamed(context, Routes.home);
        }
      });
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 32),
          styledTextField(
            context: context,
            controller: provider.loginEmailCtrl,
            label: 'Email',
            errorMessage: provider.loginEmailError,
          ),
          const SizedBox(height: 16),
          styledTextField(
            context: context,
            controller: provider.loginPasswordCtrl,
            label: 'Пароль',
            errorMessage: provider.loginPasswordError,
            obscure: true,
          ),
          const SizedBox(height: 32),
          provider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: () async {
                    final token = await getToken();
                    provider.login(token);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Войти',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                  ),
                ),
              ),
        ],
      ),
    );
  }
}

final class RegisterForm extends StatelessWidget {
  const RegisterForm({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AuthProvider>();

    final error = provider.errorEvent?.value;
    if (error != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(error)));
        }
      });
    }

    final navigation = provider.navigationEvent?.value;
    if (navigation != null && navigation == AuthProvider.navigateToUserPreferences) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          Navigator.pushReplacementNamed(context, Routes.avatarPicker);
        }
      });
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 32),
          styledTextField(
            context: context,
            controller: provider.registerNameCtrl,
            errorMessage: provider.registerNameError,
            label: 'Имя пользователя',
          ),
          const SizedBox(height: 16),
          styledTextField(
            context: context,
            controller: provider.registerEmailCtrl,
            errorMessage: provider.registerEmailError,
            label: 'Email',
          ),
          const SizedBox(height: 16),
          styledTextField(
            context: context,
            controller: provider.registerPasswordCtrl,
            label: 'Пароль',
            errorMessage: provider.registerPasswordError,
            obscure: true,
          ),
          const SizedBox(height: 16),
          styledTextField(
            context: context,
            controller: provider.registerRepeatPasswordCtrl,
            label: 'Повторите пароль',
            errorMessage: provider.registerRepeatPasswordError,
            obscure: true,
          ),
          const SizedBox(height: 32),
          provider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: () async {
                    final fcmToken = await getToken();
                    provider.register(fcmToken);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Зарегистрироваться',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                  ),
                ),
              ),
        ],
      ),
    );
  }

}

Future<String?> getToken() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    String? token = await messaging.getToken();
    log("FCM токен устройства: $token");
    return token;
  } else {
    log("Разрешение не получено на уведомления");
    return null;
  }
}

Widget styledTextField({
  required TextEditingController controller,
  required String label,
  required String? errorMessage,
  required BuildContext context,
  bool obscure = false,
}) {
  final colorSchema = Theme.of(context).colorScheme;
  final onPrimary = colorSchema.onPrimary;

  return TextFormField(
    controller: controller,
    obscureText: obscure,
    style: TextStyle(color: onPrimary),
    cursorColor: colorSchema.onPrimary,
    decoration: InputDecoration(
      labelText: label,

      errorText: errorMessage,
      filled: true,
      fillColor: Colors.transparent,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      labelStyle: TextStyle(color: onPrimary),
      floatingLabelStyle: TextStyle(color: onPrimary),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: onPrimary),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: onPrimary, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: onPrimary),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.red, width: 2),
      ),
    ),
  );
}
