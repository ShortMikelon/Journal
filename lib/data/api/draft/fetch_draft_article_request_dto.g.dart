// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fetch_draft_article_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FetchDraftArticleRequestDto _$FetchDraftArticleRequestDtoFromJson(
        Map<String, dynamic> json) =>
    FetchDraftArticleRequestDto(
      userId: (json['userId'] as num).toInt(),
      draftArticleId: (json['draftArticleId'] as num).toInt(),
    );

Map<String, dynamic> _$FetchDraftArticleRequestDtoToJson(
        FetchDraftArticleRequestDto instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'draftArticleId': instance.draftArticleId,
    };
