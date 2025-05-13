import 'package:json_annotation/json_annotation.dart';

part 'fetch_draft_article_request_dto.g.dart';

@JsonSerializable()
class FetchDraftArticleRequestDto {
  final int userId;
  final int draftArticleId;

  FetchDraftArticleRequestDto({
    required this.userId,
    required this.draftArticleId,
  });

  factory FetchDraftArticleRequestDto.fromJson(Map<String, dynamic> json) =>
      _$FetchDraftArticleRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$FetchDraftArticleRequestDtoToJson(this);
}
