import 'dart:convert';
import 'dart:typed_data';

import 'package:journal/domain/users/users_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalUserSettings implements UserSettings {
  static const _keyUsername = 'user_name';
  static const _keyEmail = 'user_email';
  static const _keyId = 'user_id';
  static const _keyAvatar = 'user_avatar';

  @override
  Future<String?> get username async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUsername);
  }

  @override
  Future<String?> get email async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyEmail);
  }

  @override
  Future<int?> get id async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyId);
  }

  @override
  Future<Uint8List?> get avatarBytes async {
    final prefs = await SharedPreferences.getInstance();
    final base64Str = prefs.getString(_keyAvatar);
    if (base64Str == null) return null;
    return base64Decode(base64Str);
  }

  @override
  Future<void> setSettings({
    required int id,
    required String name,
    required String email,
    required Uint8List? avatarBytes,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyId, id);
    await prefs.setString(_keyUsername, name);
    await prefs.setString(_keyEmail, email);

    if (avatarBytes != null) {
      final base64Str = base64Encode(avatarBytes);
      await prefs.setString(_keyAvatar, base64Str);
    } else {
      await prefs.remove(_keyAvatar);
    }
  }
}
