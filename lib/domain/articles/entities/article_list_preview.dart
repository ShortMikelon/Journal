import 'dart:typed_data';

import 'package:journal/presentations/article/list/articles_list_page.dart';
import 'package:journal/presentations/widgets/article_list_card.dart';

final class ArticleListPreviewEntity {
  final int id;
  final String title;
  final String subtitle;
  final Uint8List? imageBytes;
  final List<ArticleAuthorUi> authors;
  final int likes;
  final int comments;
  final String createdAt;

  const ArticleListPreviewEntity({
    required this.id,
    required this.title,
    required this.subtitle,
    this.imageBytes,
    required this.authors,
    required this.likes,
    required this.comments,
    required this.createdAt,
  });

  ArticleListPreviewEntity copyWith({
    int? id,
    String? title,
    String? subtitle,
    Uint8List? imageBytes,
    List<ArticleAuthorUi>? authors,
    Uint8List? authorAvatarBytes,
    int? likes,
    int? comments,
    String? createdAt,
  }) {
    return ArticleListPreviewEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      imageBytes: imageBytes ?? this.imageBytes,
      authors: authors ?? this.authors,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}