import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:journal/presentations/article/create/parameter/article_create_parameter_page.dart';
import 'package:journal/presentations/article/create/sandbox/article_create_sandbox_page.dart';
import 'package:journal/presentations/article/details/article_details_page.dart';
import 'package:journal/presentations/article/list/articles_list_page.dart';
import 'package:journal/presentations/auth/auth_page.dart';
import 'package:journal/presentations/bookmarks/bookmarks_page.dart';
import 'package:journal/presentations/profile/profile_page.dart';
import 'package:journal/presentations/routes.dart';
import 'package:journal/presentations/splash/splash_page.dart';
import 'package:journal/presentations/tabs_page.dart';
import 'package:journal/presentations/user_avatar_picker/avatar_picker_page.dart';
import 'package:journal/presentations/user_preferences/user_preferences_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const JournalApp());
}

class JournalApp extends StatelessWidget {
  const JournalApp({super.key});

  @override
  Widget build(BuildContext context) {
    final textScaler = MediaQuery.of(context).textScaler;
    final textTheme = Theme.of(context).textTheme;
    final colorsSchema = ColorScheme.light(
      primary: Colors.white,
      onPrimary: Colors.black,
      secondary: Colors.black,
      onSecondary: Colors.white,
      surface: Colors.white,
      onSurface: Colors.black,
    );

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.white,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: colorsSchema,
        textTheme: TextTheme(
          displayLarge: textTheme.displayLarge?.copyWith(
            color: colorsSchema.onPrimary,
            fontSize: textTheme.displayLarge?.fontSize != null
                ? textScaler.scale(textTheme.displayLarge!.fontSize!)
                : null,
          ),
          displayMedium: textTheme.displayMedium?.copyWith(
            color:  colorsSchema.onPrimary,
            fontSize: textTheme.displayMedium?.fontSize != null
                ? textScaler.scale(textTheme.displayMedium!.fontSize!)
                : null,
          ),
          displaySmall: textTheme.displaySmall?.copyWith(
            color:  colorsSchema.onPrimary,
            fontSize: textTheme.displaySmall?.fontSize != null
                ? textScaler.scale(textTheme.displaySmall!.fontSize!)
                : null,
          ),
          headlineLarge: textTheme.headlineLarge?.copyWith(
            color:  colorsSchema.onPrimary,
            fontSize: textTheme.headlineLarge?.fontSize != null
                ? textScaler.scale(textTheme.headlineLarge!.fontSize!)
                : null,
          ),
          headlineMedium: textTheme.headlineMedium?.copyWith(
            color:  colorsSchema.onPrimary,
            fontSize: textTheme.headlineMedium?.fontSize != null
                ? textScaler.scale(textTheme.headlineMedium!.fontSize!)
                : null,
          ),
          headlineSmall: textTheme.headlineSmall?.copyWith(
            color:  colorsSchema.onPrimary,
            fontSize: textTheme.headlineSmall?.fontSize != null
                ? textScaler.scale(textTheme.headlineSmall!.fontSize!)
                : null,
          ),
          titleLarge: textTheme.titleLarge?.copyWith(
            color:  colorsSchema.onPrimary,
            fontSize: textTheme.titleLarge?.fontSize != null
                ? textScaler.scale(textTheme.titleLarge!.fontSize!)
                : null,
          ),
          titleMedium: textTheme.titleMedium?.copyWith(
            color:  colorsSchema.onPrimary,
            fontSize: textTheme.titleMedium?.fontSize != null
                ? textScaler.scale(textTheme.titleMedium!.fontSize!)
                : null,
          ),
          titleSmall: textTheme.titleSmall?.copyWith(
            color:  colorsSchema.onPrimary,
            fontSize: textTheme.titleSmall?.fontSize != null
                ? textScaler.scale(textTheme.titleSmall!.fontSize!)
                : null,
          ),
          bodyLarge: textTheme.bodyLarge?.copyWith(
            color:  colorsSchema.onPrimary,
            fontSize: textTheme.bodyLarge?.fontSize != null
                ? textScaler.scale(textTheme.bodyLarge!.fontSize!)
                : null,
          ),
          bodyMedium: textTheme.bodyMedium?.copyWith(
            color:  colorsSchema.onPrimary,
            fontSize: textTheme.bodyMedium?.fontSize != null
                ? textScaler.scale(textTheme.bodyMedium!.fontSize!)
                : null,
          ),
          bodySmall: textTheme.bodySmall?.copyWith(
            color:  colorsSchema.onPrimary,
            fontSize: textTheme.bodySmall?.fontSize != null
                ? textScaler.scale(textTheme.bodySmall!.fontSize!)
                : null,
          ),
          labelLarge: textTheme.labelLarge?.copyWith(
            color:  colorsSchema.onPrimary,
            fontSize: textTheme.labelLarge?.fontSize != null
                ? textScaler.scale(textTheme.labelLarge!.fontSize!)
                : null,
          ),
          labelMedium: textTheme.labelMedium?.copyWith(
            color:  colorsSchema.onPrimary,
            fontSize: textTheme.labelMedium?.fontSize != null
                ? textScaler.scale(textTheme.labelMedium!.fontSize!)
                : null,
          ),
          labelSmall: textTheme.labelSmall?.copyWith(
            color:  colorsSchema.onPrimary,
            fontSize: textTheme.labelSmall?.fontSize != null
                ? textScaler.scale(textTheme.labelSmall!.fontSize!)
                : null,
          ),
        ),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Theme.of(context).colorScheme.onPrimary,
          selectionColor: Colors.blueAccent
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          elevation: 3.0,
          selectedItemColor:  colorsSchema.onPrimary,
          unselectedItemColor: Colors.grey,
          selectedIconTheme: IconThemeData(size: 30.0),
          unselectedIconTheme: IconThemeData(size: 30.0),
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
          shape: CircleBorder(),
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
          selectedIconTheme: IconThemeData(size: 30.0),
          unselectedIconTheme: IconThemeData(size: 30.0),
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
            borderRadius: BorderRadius.circular(64),
          ),
        ),
      ),
      themeMode: ThemeMode.light,
      initialRoute: Routes.splash,
      routes: {
        Routes.userPreferences: (context) => const UserPreferencesPage(),
        Routes.splash: (context) => const SplashPage(),

        Routes.home: (context) => const SafeArea(child: TabsPage()),

        Routes.articleDetails: (context) {
          final articleId = ModalRoute.of(context)!.settings.arguments as int;
          return ArticleDetailsPage(articleId: articleId);
        },

        Routes.articlesList: (context) => ArticlesListPage(),

        Routes.articleCreateSandbox: (context) {
          final draftArticleId =
              ModalRoute.of(context)!.settings.arguments as int?;
          return ArticleCreateSandboxPage(draftArticleId: draftArticleId ?? -1);
        },


        Routes.bookmarks: (context) => const BookmarksPage(),

        Routes.articleCreateParameter: (context) {
          final draftArticleId =
              ModalRoute.of(context)!.settings.arguments as int?;
          return ArticleCreateParameterPage(
            draftArticleId: draftArticleId ?? -1,
          );
        },

        // Routes.articleCreateSandboxChartPicker: (context) {
        //   // return ChartPage();
        // },

        Routes.profile: (context) {
          return ProfilePage();
        },

        Routes.auth: (context) {
          return AuthScreen();
        },

        Routes.avatarPicker: (context) => AvatarPickerPage(),
      },
    );
  }

}

