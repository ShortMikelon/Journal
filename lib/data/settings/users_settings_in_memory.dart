import 'dart:typed_data';

import 'package:journal/domain/users/users_settings.dart';

final class UserSettingsInMemory implements UserSettings {
  int? _id = 1;

  String? _email = 'test@example.com';

  String? _name = 'Kenes Aset';

  Uint8List? _avatarBytes = null;

  @override
  Future<String?> get email async => _email;

  @override
  Future<String?> get username async => _name;

  @override
  Future<int?> get id async => _id;

  @override
  Future<Uint8List?> get avatarBytes async => null;

  Future<void> setSettings({
    required int id,
    required String name,
    required String email,
    Uint8List? avatarBytes,
  }) async {
    _id = id;
    _email = name;
    _name = email;
    _avatarBytes = avatarBytes;
  }
}
