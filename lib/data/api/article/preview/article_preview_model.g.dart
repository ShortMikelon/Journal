// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article_preview_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArticlePreviewModel _$ArticlePreviewModelFromJson(Map<String, dynamic> json) =>
    ArticlePreviewModel(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      imageBytes: const Uint8ListBase64Converter()
          .fromJson(json['imageBytes'] as String?),
      authors: (json['authors'] as List<dynamic>)
          .map((e) => AuthorModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      likes: (json['likes'] as num).toInt(),
      comments: (json['comments'] as num).toInt(),
      createdAt: (json['createdAt'] as num).toInt(),
    );

Map<String, dynamic> _$ArticlePreviewModelToJson(
        ArticlePreviewModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'subtitle': instance.subtitle,
      'imageBytes':
          const Uint8ListBase64Converter().toJson(instance.imageBytes),
      'authors': instance.authors,
      'likes': instance.likes,
      'comments': instance.comments,
      'createdAt': instance.createdAt,
    };
