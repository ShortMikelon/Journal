import 'package:json_annotation/json_annotation.dart';

part 'subscribe_request_dto.g.dart';

@JsonSerializable()
class SubscribeRequestDto {
  final int userId;
  final int followerId;

  SubscribeRequestDto({
    required this.userId,
    required this.followerId,
  });

  factory SubscribeRequestDto.fromJson(Map<String, dynamic> json) =>
      _$SubscribeRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SubscribeRequestDtoToJson(this);
}
