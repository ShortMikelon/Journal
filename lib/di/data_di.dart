import 'package:journal/data/articles/articles_repository.dart';
import 'package:journal/data/authors/authors_repository.dart';
import 'package:journal/di/domain_di.dart';

final class DataDi {
  static final DataDi _instance = DataDi._internal();

  factory DataDi() => _instance;

  late final _articlesRepository = ArticlesRepository(userSettings: DomainDi().userSettings);
  ArticlesRepository get articlesRepository => _articlesRepository;

  late final _authorsRepository = AuthorsRepository();
  AuthorsRepository get authorsRepository => _authorsRepository;

  DataDi._internal();
}
