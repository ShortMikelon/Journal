final class UiComment {
  final int id;
  final int authorId;
  final String author;
  final String? authorAvatarUrl;
  final int articleId;
  final int datetime;
  final int likes;
  final String text;
  final bool isLiked;

  const UiComment({
    required this.id,
    required this.authorId,
    required this.author,
    this.authorAvatarUrl,
    required this.articleId,
    required this.datetime,
    required this.likes,
    required this.text,
    required this.isLiked,
  });

  UiComment copyWith({
    int? id,
    int? authorId,
    String? author,
    String? authorAvatarUrl,
    int? articleId,
    int? datetime,
    int? likes,
    String? text,
    bool? isLiked,
  }) {
    return UiComment(
      id: id ?? this.id,
      authorId: authorId ?? this.authorId,
      author: author ?? this.author,
      authorAvatarUrl: authorAvatarUrl ?? this.authorAvatarUrl,
      articleId: articleId ?? this.articleId,
      datetime: datetime ?? this.datetime,
      likes: likes ?? this.likes,
      text: text ?? this.text,
      isLiked: isLiked ?? this.isLiked,
    );
  }
}