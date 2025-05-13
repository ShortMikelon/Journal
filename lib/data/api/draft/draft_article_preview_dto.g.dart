// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'draft_article_preview_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DraftArticlePreviewDto _$DraftArticlePreviewDtoFromJson(
        Map<String, dynamic> json) =>
    DraftArticlePreviewDto(
      id: (json['id'] as num).toInt(),
      authors: (json['authors'] as List<dynamic>)
          .map((e) => AuthorModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      createdAt: (json['createdAt'] as num).toInt(),
      updatedAt: (json['updatedAt'] as num).toInt(),
      isPublished: json['isPublished'] as bool,
    );

Map<String, dynamic> _$DraftArticlePreviewDtoToJson(
        DraftArticlePreviewDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'authors': instance.authors,
      'title': instance.title,
      'subtitle': instance.subtitle,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'isPublished': instance.isPublished,
    };
