import 'package:journal/data/settings/users_settings_in_memory.dart';
import 'package:journal/domain/users/users_settings.dart';

final class DomainDi {
  static final DomainDi _instance = DomainDi._internal();

  factory DomainDi() => _instance;

  late final UserSettings _userSettings  = UserSettingsInMemory();
  UserSettings get userSettings => _userSettings;

  DomainDi._internal();
}
