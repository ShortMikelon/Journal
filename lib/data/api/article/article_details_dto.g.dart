// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article_details_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArticleDetailsDto _$ArticleDetailsDtoFromJson(Map<String, dynamic> json) =>
    ArticleDetailsDto(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      imageBytes: json['imageBytes'] as String?,
      authors: (json['authors'] as List<dynamic>)
          .map((e) => AuthorModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdDate: (json['createdDate'] as num).toInt(),
      updatedDate: (json['updatedDate'] as num).toInt(),
      readTime: (json['readTime'] as num).toInt(),
      content:
          (json['content'] as List<dynamic>).map((e) => e as String).toList(),
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      comments: (json['comments'] as List<dynamic>)
          .map((e) => CommentDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      likes: (json['likes'] as num).toInt(),
      isLiked: json['isLiked'] as bool,
    );

Map<String, dynamic> _$ArticleDetailsDtoToJson(ArticleDetailsDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'imageBytes': instance.imageBytes,
      'authors': instance.authors,
      'createdDate': instance.createdDate,
      'updatedDate': instance.updatedDate,
      'readTime': instance.readTime,
      'content': instance.content,
      'tags': instance.tags,
      'comments': instance.comments,
      'likes': instance.likes,
      'isLiked': instance.isLiked,
    };
