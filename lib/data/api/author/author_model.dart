
import 'dart:typed_data';

import 'package:journal/data/api/uint8list_converter.dart';
import 'package:json_annotation/json_annotation.dart';

part "author_model.g.dart";

@JsonSerializable()
class AuthorModel {
  final int authorId;
  final String authorName;
  final String authorDescription;

  @Uint8ListBase64Converter()
  final Uint8List? authorAvatarBytes;

  final int followers;
  final bool isFollowed;

  AuthorModel({
    required this.authorId,
    required this.authorName,
    required this.authorDescription,
    this.authorAvatarBytes,
    required this.followers,
    required this.isFollowed,
  });

  factory AuthorModel.fromJson(Map<String, dynamic> json) =>
      _$AuthorModelFromJson(json);

  Map<String, dynamic> toJson() => _$AuthorModelToJson(this);
}
