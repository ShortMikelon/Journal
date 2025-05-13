import 'package:journal/data/settings/local_user_settings.dart';
import 'package:journal/domain/users/users_settings.dart';

final class DomainDi {
  static final DomainDi _instance = DomainDi._internal();

  factory DomainDi() => _instance;

  late final UserSettings _userSettings  = LocalUserSettings();
  UserSettings get userSettings => _userSettings;

  DomainDi._internal();
}
