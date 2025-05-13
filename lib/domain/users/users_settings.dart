import 'dart:typed_data';

abstract interface class UserSettings {
  Future<String?> get username;
  Future<String?> get email;
  Future<int?> get id;
  Future<Uint8List?> get avatarBytes;

  Future<void> setSettings({
    required int id,
    required String name,
    required String email,
    required Uint8List? avatarBytes,
  });
}