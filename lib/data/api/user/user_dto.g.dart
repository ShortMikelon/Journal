// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserDto _$UserDtoFromJson(Map<String, dynamic> json) => UserDto(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      aboutMe: json['aboutMe'] as String,
      avatarBytes: UserDto._fromBase64(json['avatarBytes'] as String?),
      followers: (json['followers'] as num).toInt(),
      followings: (json['followings'] as num).toInt(),
      isFollowed: json['isFollowed'] as bool,
    );

Map<String, dynamic> _$UserDtoToJson(UserDto instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'aboutMe': instance.aboutMe,
      'avatarBytes': UserDto._toBase64(instance.avatarBytes),
      'followers': instance.followers,
      'followings': instance.followings,
      'isFollowed': instance.isFollowed,
    };
