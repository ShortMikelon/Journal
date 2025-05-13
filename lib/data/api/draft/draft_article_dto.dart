import 'package:json_annotation/json_annotation.dart';
import '../author/author_model.dart';

part 'draft_article_dto.g.dart';

@JsonSerializable()
class DraftArticleDto {
  final int id;
  final List<AuthorModel> authors;
  final String title;
  final String subtitle;
  final int createdAt;
  final int updatedAt;
  final bool isPublished;
  final List<String> contents;
  final List<String> tags;

  DraftArticleDto({
    required this.id,
    required this.authors,
    required this.title,
    required this.subtitle,
    required this.createdAt,
    required this.updatedAt,
    required this.isPublished,
    required this.contents,
    required this.tags,
  });

  factory DraftArticleDto.fromJson(Map<String, dynamic> json) =>
      _$DraftArticleDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DraftArticleDtoToJson(this);
}
