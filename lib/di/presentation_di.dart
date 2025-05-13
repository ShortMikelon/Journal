import 'package:journal/di/data_di.dart';
import 'package:journal/presentations/article/create/sandbox/article_create_sandbox_provider.dart';
import 'package:journal/presentations/article/details/article_details_provider.dart';
import 'package:journal/presentations/article/list/articles_list_provider.dart';
import 'package:journal/presentations/splash/splash_provider.dart';

import 'domain_di.dart';

final class PresentationDi {
  static final PresentationDi _instance = PresentationDi._internal();

  factory PresentationDi() => _instance;

  late final _articlesListProvider = ArticlesListProvider(
      articlesRepository: DataDi().articlesRepository,
      tagRepository: DataDi().tagRepository);

  ArticlesListProvider get articlesListProvider => _articlesListProvider;

  // late final _articleDetailsProvider = ArticleDetailsProvider(
  //     articlesRepository: DataDi().articlesRepository);
  //
  // ArticleDetailsProvider get articleDetailsProvider => _articleDetailsProvider;

  late final _splashProvider = SplashProvider();

  SplashProvider get splashProvider => _splashProvider;

  late final _articleCreateSandboxProvider = ArticleCreateSandboxProvider(
    userSettings: DomainDi().userSettings,
    draftArticlesRepository: DataDi().draftArticleRepository,
  );

  ArticleCreateSandboxProvider get articleCreateSandboxProvider => _articleCreateSandboxProvider;

  PresentationDi._internal();
}