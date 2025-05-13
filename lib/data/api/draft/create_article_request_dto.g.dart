// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_article_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateArticleRequestDto _$CreateArticleRequestDtoFromJson(
        Map<String, dynamic> json) =>
    CreateArticleRequestDto(
      authorIds: (json['authorIds'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      contents:
          (json['contents'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$CreateArticleRequestDtoToJson(
        CreateArticleRequestDto instance) =>
    <String, dynamic>{
      'authorIds': instance.authorIds,
      'title': instance.title,
      'subtitle': instance.subtitle,
      'contents': instance.contents,
    };
