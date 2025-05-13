import 'package:journal/data/articles/articles_repository.dart';
import 'package:journal/data/articles/draft/draft_articles_repository.dart';
import 'package:journal/data/auth_repository.dart';
import 'package:journal/data/authors/authors_repository.dart';
import 'package:journal/data/tag/tag_repository.dart';
import 'package:journal/data/users/users_repository.dart';
import 'package:journal/di/domain_di.dart';

final class DataDi {
  static final DataDi _instance = DataDi._internal();

  factory DataDi() => _instance;

  late final _usersRepository = UsersRepository();
  UsersRepository get usersRepository => _usersRepository;

  late final _articlesRepository = ArticlesRepository(userSettings: DomainDi().userSettings);
  ArticlesRepository get articlesRepository => _articlesRepository;

  late final _authorsRepository = AuthorsRepository();
  AuthorsRepository get authorsRepository => _authorsRepository;

  late final _draftRepository = DraftArticlesRepository();
  DraftArticlesRepository get draftArticleRepository => _draftRepository;

  late final _tagRepository = TagRepository();
  TagRepository get tagRepository => _tagRepository;

  late final _accountRepository = AccountRepository();
  AccountRepository get accountRepository => _accountRepository;

  DataDi._internal();
}
