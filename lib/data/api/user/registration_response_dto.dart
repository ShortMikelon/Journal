import 'package:json_annotation/json_annotation.dart';

part 'registration_response_dto.g.dart';

@JsonSerializable()
final class RegistrationResponseDto {
  final int id;

  const RegistrationResponseDto({required this.id});

  factory RegistrationResponseDto.fromJson(Map<String, dynamic> json) =>
      _$RegistrationResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$RegistrationResponseDtoToJson(this);
}
