import 'package:json_annotation/json_annotation.dart';

part 'fetch_all_article_by_author_request_dto.g.dart';

@JsonSerializable()
class FetchAllArticleByAuthorRequestDto {
  final int userId;
  final int authorId;

  FetchAllArticleByAuthorRequestDto({
    required this.userId,
    required this.authorId,
  });

  factory FetchAllArticleByAuthorRequestDto.fromJson(Map<String, dynamic> json) =>
      _$FetchAllArticleByAuthorRequestDtoFromJson(json);

  Map<String, dynamic> toJson() =>
      _$FetchAllArticleByAuthorRequestDtoToJson(this);
}
