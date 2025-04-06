final class ArticleListPreviewEntity {
  final int id;
  final String title;
  final String subtitle;
  final String? imageUrl;
  final String author;
  final String? authorAvatarUrl;
  final int likes;
  final int comments;
  final String createdAt;

  const ArticleListPreviewEntity({
    required this.id,
    required this.title,
    required this.subtitle,
    this.imageUrl,
    required this.author,
    this.authorAvatarUrl,
    required this.likes,
    required this.comments,
    required this.createdAt,
  });

  ArticleListPreviewEntity copyWith({
    int? id,
    String? title,
    String? subtitle,
    String? imageUrl,
    String? author,
    String? authorAvatarUrl,
    int? likes,
    int? comments,
    String? createdAt,
  }) {
    return ArticleListPreviewEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      imageUrl: imageUrl ?? this.imageUrl,
      author: author ?? this.author,
      authorAvatarUrl: authorAvatarUrl ?? this.authorAvatarUrl,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}