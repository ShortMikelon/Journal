final class ArticleEntity {
  final int id;
  final int authorId;
  final String title;
  final String subtitle;
  final String? imageUrl;
  final List<String> content;
  final List<String> tags;
  final int readTime;
  final int createdDate;

  const ArticleEntity({
    required this.id,
    required this.authorId,
    required this.title,
    required this.subtitle,
    this.readTime = 0,
    this.imageUrl,
    required this.content,
    required this.tags,
    required this.createdDate,
  });

  ArticleEntity copyWith({
    int? id,
    int? authorId,
    String? title,
    String? subtitle,
    List<String>? body,
    List<String>? tags,
    int? createdDate,
    int? readTime,
    int? likes,
    int? comments,
  }) {
    return ArticleEntity(
      id: id ?? this.id,
      authorId: authorId ?? this.authorId,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      content: body ?? content,
      readTime: readTime ?? this.readTime,
      tags: tags ?? this.tags,
      createdDate: createdDate ?? this.createdDate,
    );
  }
}