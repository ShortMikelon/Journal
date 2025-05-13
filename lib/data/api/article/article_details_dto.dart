import 'package:journal/data/api/author/author_model.dart';
import 'package:journal/data/api/comment/comment_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'article_details_dto.g.dart';

@JsonSerializable()
class ArticleDetailsDto {
  final int id;
  final String title;
  final String? imageBytes;
  final List<AuthorModel> authors;
  final int createdDate;
  final int updatedDate;
  final int readTime;
  final List<String> content;
  final List<String> tags;
  final List<CommentDto> comments;
  final int likes;
  final bool isLiked;

  factory ArticleDetailsDto.fromJson(Map<String, dynamic> json) =>
      _$ArticleDetailsDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ArticleDetailsDtoToJson(this);

  const ArticleDetailsDto({
    required this.id,
    required this.title,
    this.imageBytes,
    required this.authors,
    required this.createdDate,
    required this.updatedDate,
    required this.readTime,
    required this.content,
    required this.tags,
    required this.comments,
    required this.likes,
    required this.isLiked,
  });
}
