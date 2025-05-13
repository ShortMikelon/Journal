import 'dart:convert';
import 'dart:typed_data';
import 'package:json_annotation/json_annotation.dart';

part 'user_dto.g.dart';

@JsonSerializable()
class UserDto {
  final int id;
  final String name;
  final String aboutMe;

  @JsonKey(fromJson: _fromBase64, toJson: _toBase64)
  final Uint8List? avatarBytes;

  final int followers;
  final int followings;
  final bool isFollowed;

  UserDto({
    required this.id,
    required this.name,
    required this.aboutMe,
    required this.avatarBytes,
    required this.followers,
    required this.followings,
    required this.isFollowed,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UserDtoToJson(this);

  static Uint8List? _fromBase64(String? bytes) =>
      bytes == null ? null : Uint8List.fromList(const Base64Decoder().convert(bytes));

  static String? _toBase64(Uint8List? bytes) =>
      bytes == null ? null : const Base64Encoder().convert(bytes);
}
