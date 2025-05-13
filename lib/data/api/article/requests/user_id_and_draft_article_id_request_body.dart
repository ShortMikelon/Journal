import 'package:json_annotation/json_annotation.dart';

part 'user_id_and_draft_article_id_request_body.g.dart';

@JsonSerializable()
class UserIdAndDraftArticleIdRequestBody {
  final int userId;
  final int draftArticleId;

  UserIdAndDraftArticleIdRequestBody({
    required this.userId,
    required this.draftArticleId,
  });

  factory UserIdAndDraftArticleIdRequestBody.fromJson(Map<String, dynamic> json) =>
      _$UserIdAndDraftArticleIdRequestBodyFromJson(json);

  Map<String, dynamic> toJson() =>
      _$UserIdAndDraftArticleIdRequestBodyToJson(this);
}
