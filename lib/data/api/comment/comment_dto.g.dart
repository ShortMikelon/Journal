// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommentDto _$CommentDtoFromJson(Map<String, dynamic> json) => CommentDto(
      id: (json['id'] as num).toInt(),
      authorId: (json['authorId'] as num).toInt(),
      author: json['author'] as String,
      avatarAuthorBytes: json['avatarAuthorBytes'] as String?,
      articleId: (json['articleId'] as num).toInt(),
      createdAt: (json['createdAt'] as num).toInt(),
      likes: (json['likes'] as num).toInt(),
      text: json['text'] as String,
      isLiked: json['isLiked'] as bool,
    );

Map<String, dynamic> _$CommentDtoToJson(CommentDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'authorId': instance.authorId,
      'author': instance.author,
      'avatarAuthorBytes': instance.avatarAuthorBytes,
      'articleId': instance.articleId,
      'createdAt': instance.createdAt,
      'likes': instance.likes,
      'text': instance.text,
      'isLiked': instance.isLiked,
    };
