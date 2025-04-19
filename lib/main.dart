import 'package:flutter/material.dart';
import 'package:journal/presentations/article/create/parameter/article_create_parameter_page.dart';
import 'package:journal/presentations/article/create/sandbox/article_create_sandbox_page.dart';
import 'package:journal/presentations/article/details/article_details_page.dart';
import 'package:journal/presentations/article/list/articles_list_page.dart';
import 'package:journal/presentations/routes.dart';
import 'package:journal/presentations/splash/splash_page.dart';

void main() {
 runApp(const JournalApp());
}

class JournalApp extends StatelessWidget {
  const JournalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.white,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.light(
          primary: Colors.white,
          onPrimary: Colors.black,
          secondary: Colors.black,
          onSecondary: Colors.white,
          surface: Colors.white,
          onSurface: Colors.black,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black),
          bodyMedium: TextStyle(color: Colors.black),
          titleMedium: TextStyle(color: Colors.black),
          headlineMedium: TextStyle(color: Colors.black),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          elevation: 3.0,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
          selectedIconTheme: IconThemeData(
            size: 30.0,
          ),
          unselectedIconTheme: IconThemeData(
            size: 30.0
          ),
          selectedLabelStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.normal,
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          iconSize: 30.0,
          elevation: 6.0,
          hoverElevation: 8.0,
          focusElevation: 8.0,
          highlightElevation: 10.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Colors.black,
        colorScheme: ColorScheme.dark(
          primary: Colors.black,
          onPrimary: Colors.white, // текст на чёрном фоне
          secondary: Colors.white,
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.black,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
          selectedIconTheme: IconThemeData(
            size: 30.0,
          ),
          unselectedIconTheme: IconThemeData(
              size: 30.0
          ),
          selectedLabelStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.normal,
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          elevation: 6.0,
          hoverElevation: 8.0,
          focusElevation: 8.0,
          highlightElevation: 10.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      themeMode: ThemeMode.system,
      initialRoute: Routes.splash,
      routes: {
        Routes.splash: (context) => const SplashPage(),
        Routes.home: (context) => const SafeArea(child: ArticlesListPage()),
        Routes.articleDetails: (context) {
          final articleId = ModalRoute.of(context)!.settings.arguments as int;
          return ArticleDetailsPage(articleId: articleId);
        },
        Routes.articleCreateSandbox: (context) {
          final draftArticleId = ModalRoute.of(context)!.settings.arguments as int?;
          return ArticleCreateSandboxPage(draftArticleId: draftArticleId ?? -1);
        },

        Routes.articleCreateParameter: (context) {
          final draftArticleId = ModalRoute.of(context)!.settings.arguments as int?;
          return ArticleCreateParameterPage(draftArticleId: draftArticleId ?? -1);
        }
      },
    );
  }
}
