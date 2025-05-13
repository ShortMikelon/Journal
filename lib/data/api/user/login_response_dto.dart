import 'dart:typed_data';

import 'package:journal/data/api/uint8list_converter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'login_response_dto.g.dart';

@JsonSerializable()
class LoginResponseDto {
  final int id;
  final String name;
  final String email;

  @Uint8ListBase64Converter()
  final Uint8List? avatarBytes;

  LoginResponseDto({
    required this.id,
    required this.name,
    required this.email,
    this.avatarBytes,
  });

  factory LoginResponseDto.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseDtoToJson(this);
}
