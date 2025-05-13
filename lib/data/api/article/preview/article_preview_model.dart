import 'dart:typed_data';

import 'package:journal/data/api/uint8list_converter.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../author/author_model.dart';

part 'article_preview_model.g.dart';

@JsonSerializable()
class ArticlePreviewModel {
  final int id;
  final String title;
  final String subtitle;

  @Uint8ListBase64Converter()
  final Uint8List? imageBytes;

  final List<AuthorModel> authors;
  final int likes;
  final int comments;
  final int createdAt;

  ArticlePreviewModel({
    required this.id,
    required this.title,
    required this.subtitle,
    this.imageBytes,
    required this.authors,
    required this.likes,
    required this.comments,
    required this.createdAt,
  });

  factory ArticlePreviewModel.fromJson(Map<String, dynamic> json) =>
      _$ArticlePreviewModelFromJson(json);

  Map<String, dynamic> toJson() => _$ArticlePreviewModelToJson(this);
}
