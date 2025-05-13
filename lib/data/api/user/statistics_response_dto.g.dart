// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'statistics_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StatisticsResponseDto _$StatisticsResponseDtoFromJson(
        Map<String, dynamic> json) =>
    StatisticsResponseDto(
      read: Map<String, int>.from(json['read'] as Map),
      write: Map<String, int>.from(json['write'] as Map),
      reader: Map<String, int>.from(json['reader'] as Map),
    );

Map<String, dynamic> _$StatisticsResponseDtoToJson(
        StatisticsResponseDto instance) =>
    <String, dynamic>{
      'read': instance.read,
      'write': instance.write,
      'reader': instance.reader,
    };
