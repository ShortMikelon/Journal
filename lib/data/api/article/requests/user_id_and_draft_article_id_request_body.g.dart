// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_id_and_draft_article_id_request_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserIdAndDraftArticleIdRequestBody _$UserIdAndDraftArticleIdRequestBodyFromJson(
        Map<String, dynamic> json) =>
    UserIdAndDraftArticleIdRequestBody(
      userId: (json['userId'] as num).toInt(),
      draftArticleId: (json['draftArticleId'] as num).toInt(),
    );

Map<String, dynamic> _$UserIdAndDraftArticleIdRequestBodyToJson(
        UserIdAndDraftArticleIdRequestBody instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'draftArticleId': instance.draftArticleId,
    };
