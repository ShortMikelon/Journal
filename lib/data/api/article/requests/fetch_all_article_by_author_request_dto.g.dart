// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fetch_all_article_by_author_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FetchAllArticleByAuthorRequestDto _$FetchAllArticleByAuthorRequestDtoFromJson(
        Map<String, dynamic> json) =>
    FetchAllArticleByAuthorRequestDto(
      userId: (json['userId'] as num).toInt(),
      authorId: (json['authorId'] as num).toInt(),
    );

Map<String, dynamic> _$FetchAllArticleByAuthorRequestDtoToJson(
        FetchAllArticleByAuthorRequestDto instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'authorId': instance.authorId,
    };
