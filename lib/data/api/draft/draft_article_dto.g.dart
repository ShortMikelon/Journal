// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'draft_article_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DraftArticleDto _$DraftArticleDtoFromJson(Map<String, dynamic> json) =>
    DraftArticleDto(
      id: (json['id'] as num).toInt(),
      authors: (json['authors'] as List<dynamic>)
          .map((e) => AuthorModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      createdAt: (json['createdAt'] as num).toInt(),
      updatedAt: (json['updatedAt'] as num).toInt(),
      isPublished: json['isPublished'] as bool,
      contents:
          (json['contents'] as List<dynamic>).map((e) => e as String).toList(),
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$DraftArticleDtoToJson(DraftArticleDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'authors': instance.authors,
      'title': instance.title,
      'subtitle': instance.subtitle,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'isPublished': instance.isPublished,
      'contents': instance.contents,
      'tags': instance.tags,
    };
