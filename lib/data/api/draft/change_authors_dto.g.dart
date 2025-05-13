// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'change_authors_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChangeAuthorsDto _$ChangeAuthorsDtoFromJson(Map<String, dynamic> json) =>
    ChangeAuthorsDto(
      draftArticleId: (json['draftArticleId'] as num).toInt(),
      authorIds: (json['authorIds'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
    );

Map<String, dynamic> _$ChangeAuthorsDtoToJson(ChangeAuthorsDto instance) =>
    <String, dynamic>{
      'draftArticleId': instance.draftArticleId,
      'authorIds': instance.authorIds,
    };
