// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileResponseDto _$ProfileResponseDtoFromJson(Map<String, dynamic> json) =>
    ProfileResponseDto(
      id: (json['id'] as num).toInt(),
      aboutMe: json['aboutMe'] as String,
      followers: (json['followers'] as num).toInt(),
      followings: (json['followings'] as num).toInt(),
      name: json['name'] as String,
      avatarBytes: const Uint8ListBase64Converter()
          .fromJson(json['avatarBytes'] as String?),
    );

Map<String, dynamic> _$ProfileResponseDtoToJson(ProfileResponseDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'aboutMe': instance.aboutMe,
      'followers': instance.followers,
      'followings': instance.followings,
      'name': instance.name,
      'avatarBytes':
          const Uint8ListBase64Converter().toJson(instance.avatarBytes),
    };
