// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'save_article_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SaveArticleRequestDto _$SaveArticleRequestDtoFromJson(
        Map<String, dynamic> json) =>
    SaveArticleRequestDto(
      draftId: (json['draftId'] as num).toInt(),
      title: json['title'] as String?,
      subtitle: json['subtitle'] as String?,
      userId: (json['userId'] as num).toInt(),
      contents: (json['contents'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$SaveArticleRequestDtoToJson(
        SaveArticleRequestDto instance) =>
    <String, dynamic>{
      'draftId': instance.draftId,
      'title': instance.title,
      'subtitle': instance.subtitle,
      'userId': instance.userId,
      'contents': instance.contents,
      'tags': instance.tags,
    };
