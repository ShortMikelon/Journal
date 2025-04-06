import 'package:journal/domain/users/users_settings.dart';

final class UserSettingsInMemory implements UserSettings {
  @override
  String get email => 'as.kenes@aues.kz';

  @override
  String get username => 'Kenes Aset';

  @override
  int get id => 1;

  @override
  String? get avatarUrl => null;

}