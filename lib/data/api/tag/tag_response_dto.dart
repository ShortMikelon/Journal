import 'package:json_annotation/json_annotation.dart';

part 'tag_response_dto.g.dart';

@JsonSerializable()
class TagResponseDto {
  final String name;

  TagResponseDto({required this.name});

  factory TagResponseDto.fromJson(Map<String, dynamic> json) =>
      _$TagResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$TagResponseDtoToJson(this);
}
