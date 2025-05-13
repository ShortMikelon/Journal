// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'author_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthorModel _$AuthorModelFromJson(Map<String, dynamic> json) => AuthorModel(
      authorId: (json['authorId'] as num).toInt(),
      authorName: json['authorName'] as String,
      authorDescription: json['authorDescription'] as String,
      authorAvatarBytes: const Uint8ListBase64Converter()
          .fromJson(json['authorAvatarBytes'] as String?),
      followers: (json['followers'] as num).toInt(),
      isFollowed: json['isFollowed'] as bool,
    );

Map<String, dynamic> _$AuthorModelToJson(AuthorModel instance) =>
    <String, dynamic>{
      'authorId': instance.authorId,
      'authorName': instance.authorName,
      'authorDescription': instance.authorDescription,
      'authorAvatarBytes':
          const Uint8ListBase64Converter().toJson(instance.authorAvatarBytes),
      'followers': instance.followers,
      'isFollowed': instance.isFollowed,
    };
