// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'registration_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegistrationRequestDto _$RegistrationRequestDtoFromJson(
        Map<String, dynamic> json) =>
    RegistrationRequestDto(
      email: json['email'] as String,
      name: json['name'] as String,
      password: json['password'] as String,
      userPreferences: (json['userPreferences'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      aboutMe: json['aboutMe'] as String?,
      fcmToken: json['fcmToken'] as String,
      avatarBytes: const Uint8ListBase64Converter()
          .fromJson(json['avatarBytes'] as String?),
    );

Map<String, dynamic> _$RegistrationRequestDtoToJson(
        RegistrationRequestDto instance) =>
    <String, dynamic>{
      'email': instance.email,
      'name': instance.name,
      'password': instance.password,
      'userPreferences': instance.userPreferences,
      'aboutMe': instance.aboutMe,
      'fcmToken': instance.fcmToken,
      'avatarBytes':
          const Uint8ListBase64Converter().toJson(instance.avatarBytes),
    };
