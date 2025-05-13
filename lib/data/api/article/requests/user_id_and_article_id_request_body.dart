import 'package:json_annotation/json_annotation.dart';

part 'user_id_and_article_id_request_body.g.dart';

@JsonSerializable()
class UserIdAndArticleIdRequestBody {
  final int userId;
  final int articleId;

  UserIdAndArticleIdRequestBody({
    required this.userId,
    required this.articleId,
  });

  factory UserIdAndArticleIdRequestBody.fromJson(Map<String, dynamic> json) =>
      _$UserIdAndArticleIdRequestBodyFromJson(json);

  Map<String, dynamic> toJson() =>
      _$UserIdAndArticleIdRequestBodyToJson(this);
}