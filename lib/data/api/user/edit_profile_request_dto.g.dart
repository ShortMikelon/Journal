// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edit_profile_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EditProfileRequestDto _$EditProfileRequestDtoFromJson(
        Map<String, dynamic> json) =>
    EditProfileRequestDto(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String?,
      aboutMe: json['aboutMe'] as String?,
      userPreferences: (json['userPreferences'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      avatarBytes: const Uint8ListBase64Converter()
          .fromJson(json['avatarBytes'] as String?),
    );

Map<String, dynamic> _$EditProfileRequestDtoToJson(
        EditProfileRequestDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'aboutMe': instance.aboutMe,
      'userPreferences': instance.userPreferences,
      'avatarBytes':
          const Uint8ListBase64Converter().toJson(instance.avatarBytes),
    };
