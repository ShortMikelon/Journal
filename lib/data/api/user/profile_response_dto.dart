import 'dart:typed_data';

import 'package:journal/data/api/uint8list_converter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'profile_response_dto.g.dart';

@JsonSerializable()
class ProfileResponseDto {
  final int id;
  final String aboutMe;
  final int followers;
  final int followings;
  final String name;

  // Мы предполагаем, что avatarBytes передается как строка (например, Base64)
  @Uint8ListBase64Converter()
  final Uint8List? avatarBytes;

  ProfileResponseDto({
    required this.id,
    required this.aboutMe,
    required this.followers,
    required this.followings,
    required this.name,
    required this.avatarBytes,
  });

  factory ProfileResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ProfileResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileResponseDtoToJson(this);
}
