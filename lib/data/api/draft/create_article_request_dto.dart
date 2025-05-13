import 'package:json_annotation/json_annotation.dart';

part 'create_article_request_dto.g.dart';

@JsonSerializable()
class CreateArticleRequestDto {
  final List<int> authorIds;
  final String title;
  final String subtitle;
  final List<String> contents;

  CreateArticleRequestDto({
    required this.authorIds,
    required this.title,
    required this.subtitle,
    required this.contents,
  });

  factory CreateArticleRequestDto.fromJson(Map<String, dynamic> json) =>
      _$CreateArticleRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CreateArticleRequestDtoToJson(this);
}
