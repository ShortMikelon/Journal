// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscribe_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubscribeRequestDto _$SubscribeRequestDtoFromJson(Map<String, dynamic> json) =>
    SubscribeRequestDto(
      userId: (json['userId'] as num).toInt(),
      followerId: (json['followerId'] as num).toInt(),
    );

Map<String, dynamic> _$SubscribeRequestDtoToJson(
        SubscribeRequestDto instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'followerId': instance.followerId,
    };
