// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fetch_article_by_id_request_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FetchArticleByIdRequestBody _$FetchArticleByIdRequestBodyFromJson(
        Map<String, dynamic> json) =>
    FetchArticleByIdRequestBody(
      userId: (json['userId'] as num).toInt(),
      articleId: (json['articleId'] as num).toInt(),
    );

Map<String, dynamic> _$FetchArticleByIdRequestBodyToJson(
        FetchArticleByIdRequestBody instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'articleId': instance.articleId,
    };
