import 'package:json_annotation/json_annotation.dart';

part 'save_article_request_dto.g.dart';

@JsonSerializable()
class SaveArticleRequestDto {
  final int draftId;
  final String? title;
  final String? subtitle;
  final int userId;
  final List<String>? contents;
  final List<String>? tags;

  SaveArticleRequestDto({
    required this.draftId,
    this.title,
    this.subtitle,
    required this.userId,
    this.contents,
    this.tags,
  });

  factory SaveArticleRequestDto.fromJson(Map<String, dynamic> json) =>
      _$SaveArticleRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SaveArticleRequestDtoToJson(this);
}
