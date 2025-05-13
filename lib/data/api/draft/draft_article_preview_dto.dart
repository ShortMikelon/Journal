import 'package:journal/data/api/author/author_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'draft_article_preview_dto.g.dart';

@JsonSerializable()
class DraftArticlePreviewDto {
  final int id;
  final List<AuthorModel> authors;
  final String title;
  final String subtitle;
  final int createdAt;
  final int updatedAt;
  final bool isPublished;

  DraftArticlePreviewDto({
    required this.id,
    required this.authors,
    required this.title,
    required this.subtitle,
    required this.createdAt,
    required this.updatedAt,
    required this.isPublished,
  });

  factory DraftArticlePreviewDto.fromJson(Map<String, dynamic> json) =>
      _$DraftArticlePreviewDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DraftArticlePreviewDtoToJson(this);
}
