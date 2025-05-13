import 'dart:typed_data';

import 'package:json_annotation/json_annotation.dart';

import '../uint8list_converter.dart';

part 'edit_profile_request_dto.g.dart';

@JsonSerializable()
class EditProfileRequestDto {
  final int id;
  final String? name;
  final String? aboutMe;
  final List<String>? userPreferences;

  @Uint8ListBase64Converter()
  final Uint8List? avatarBytes;

  EditProfileRequestDto({
    required this.id,
    this.name,
    this.aboutMe,
    this.userPreferences,
    this.avatarBytes,
  });

  factory EditProfileRequestDto.fromJson(Map<String, dynamic> json) =>
      _$EditProfileRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$EditProfileRequestDtoToJson(this);
}
