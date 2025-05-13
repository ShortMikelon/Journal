import 'dart:developer';
import 'dart:typed_data';

import 'package:journal/data/api/user/edit_profile_request_dto.dart';
import 'package:journal/data/api/user/login_request_dto.dart';
import 'package:journal/data/api/user/registration_request_dto.dart';
import 'package:journal/data/api_service.dart';
import 'package:journal/data/tag/tag_repository.dart';
import 'package:journal/di/domain_di.dart';

final class AccountRepository {
  final apiClient = ApiService.client;
  final userSettings = DomainDi().userSettings;

  Future<void> registration({
    required String email,
    required String name,
    required String password,
    required String? fcmToken,
    Uint8List? avatarBytes,
  }) async {
    final request = RegistrationRequestDto(
      email: email,
      name: name,
      password: password,
      aboutMe: null,
      avatarBytes: avatarBytes,
        fcmToken: fcmToken,
    );

    final response = await apiClient.registration(request);

    userSettings.setSettings(
      id: response.id,
      name: request.name,
      email: request.email,
      avatarBytes: avatarBytes,
    );
  }

  Future<void> login(LoginRequestDto loginDto) async {
    final response = await apiClient.login(loginDto);

    userSettings.setSettings(
      id: response.id,
      name: response.name,
      email: response.email,
      avatarBytes: response.avatarBytes,
    );
  }

  Future<void> edit({
    String? name,
    String? aboutMe,
    List<String>? userPreferences,
  }) async {
    final editDto = EditProfileRequestDto(
      id: (await userSettings.id)!,
      name: name,
      aboutMe: aboutMe,
      userPreferences: userPreferences,
    );

    apiClient.editProfile(editDto);
  }

  Future<void> editUserPreferences(List<Tag> userPreferences) async {
    final requestBody = EditProfileRequestDto(
      id: (await userSettings.id)!,
      userPreferences: userPreferences.map((tag) => tag.name).toList(),
    );

    apiClient.editProfile(requestBody);
  }

  Future<void> editAvatar(Uint8List? avatar) async {
    log('edit avatar called');
    final editDto = EditProfileRequestDto(
      id: (await userSettings.id)!,
      name: null,
      aboutMe: null,
      userPreferences: null,
      avatarBytes: avatar
    );

    await apiClient.editProfile(editDto);
  }

  Future<void> exit() async {}

  Future<void> deleteAccount() async {}

  Future<bool> isSignIn() async {
    return (await userSettings.id) != null;
  }
}
