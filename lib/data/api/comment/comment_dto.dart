import 'package:json_annotation/json_annotation.dart';

part 'comment_dto.g.dart';

@JsonSerializable()
class CommentDto {
  final int id;
  final int authorId;
  final String author;
  final String? avatarAuthorBytes;
  final int articleId;
  final int createdAt;
  final int likes;
  final String text;
  final bool isLiked;

  CommentDto({
    required this.id,
    required this.authorId,
    required this.author,
    this.avatarAuthorBytes,
    required this.articleId,
    required this.createdAt,
    required this.likes,
    required this.text,
    required this.isLiked,
  });

  factory CommentDto.fromJson(Map<String, dynamic> json) =>
      _$CommentDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CommentDtoToJson(this);
}
