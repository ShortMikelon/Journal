import 'package:json_annotation/json_annotation.dart';

part 'fetch_article_by_id_request_body.g.dart';

@JsonSerializable()
class FetchArticleByIdRequestBody {
  final int userId;
  final int articleId;

  FetchArticleByIdRequestBody({
    required this.userId,
    required this.articleId,
  });

  factory FetchArticleByIdRequestBody.fromJson(Map<String, dynamic> json) =>
      _$FetchArticleByIdRequestBodyFromJson(json);

  Map<String, dynamic> toJson() => _$FetchArticleByIdRequestBodyToJson(this);
}