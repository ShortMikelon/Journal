

import 'dart:typed_data';

import 'package:json_annotation/json_annotation.dart';

import '../uint8list_converter.dart';

part 'registration_request_dto.g.dart';

@JsonSerializable()
class RegistrationRequestDto {
  final String email;
  final String name;
  final String password;
  final List<String>? userPreferences;
  final String? aboutMe;
  final String? fcmToken;

  @Uint8ListBase64Converter()
  final Uint8List? avatarBytes;

  factory RegistrationRequestDto.fromJson(Map<String, dynamic> json) =>
      _$RegistrationRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$RegistrationRequestDtoToJson(this);

  const RegistrationRequestDto({
    required this.email,
    required this.name,
    required this.password,
    this.userPreferences,
    this.aboutMe,
    required this.fcmToken,
    this.avatarBytes,
  });
}
