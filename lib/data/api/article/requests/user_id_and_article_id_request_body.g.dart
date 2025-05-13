// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_id_and_article_id_request_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserIdAndArticleIdRequestBody _$UserIdAndArticleIdRequestBodyFromJson(
        Map<String, dynamic> json) =>
    UserIdAndArticleIdRequestBody(
      userId: (json['userId'] as num).toInt(),
      articleId: (json['articleId'] as num).toInt(),
    );

Map<String, dynamic> _$UserIdAndArticleIdRequestBodyToJson(
        UserIdAndArticleIdRequestBody instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'articleId': instance.articleId,
    };
