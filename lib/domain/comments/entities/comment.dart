final class Comment {
  final int id;
  final int authorId;
  final int articleId;
  final int datetime;
  final int likes;
  final bool isLiked;
  final String text;

  const Comment({
    required this.id,
    required this.authorId,
    required this.articleId,
    required this.datetime,
    required this.likes,
    required this.isLiked,
    required this.text,
  });

  Comment copyWith({
    int? id,
    int? authorId,
    int? articleId,
    int? datetime,
    int? likes,
    bool? isLiked,
    String? text,
  }) {
    return Comment(
      id: id ?? this.id,
      authorId: authorId ?? this.authorId,
      articleId: articleId ?? this.articleId,
      datetime: datetime ?? this.datetime,
      likes: likes ?? this.likes,
      isLiked: isLiked ?? this.isLiked,
      text: text ?? this.text,
    );
  }
}