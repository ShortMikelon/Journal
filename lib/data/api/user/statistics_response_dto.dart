import 'package:json_annotation/json_annotation.dart';

part 'statistics_response_dto.g.dart';

@JsonSerializable()
class StatisticsResponseDto {
  final Map<String, int> read;
  final Map<String, int> write;
  final Map<String, int> reader;

  StatisticsResponseDto({
    required this.read,
    required this.write,
    required this.reader,
  });

  factory StatisticsResponseDto.fromJson(Map<String, dynamic> json) =>
      _$StatisticsResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$StatisticsResponseDtoToJson(this);
}
