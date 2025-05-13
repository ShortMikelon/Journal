
import 'package:journal/data/tag/tag_repository.dart';
import 'package:journal/domain/articles/entities/draft_article.dart';

final class CreateArticleEntity {
  final String title;
  final String subtitle;
  final String? imageUrl;
  final int publishedDate;
  final List<BodyComponent> bodyComponents;
  final List<Tag> tags;

  const CreateArticleEntity({
    required this.title,
    required this.subtitle,
    this.imageUrl,
    required this.publishedDate,
    required this.bodyComponents,
    required this.tags,
  });

  CreateArticleEntity copyWith({
    String? title,
    String? subtitle,
    String? imageUrl,
    int? publishedDate,
    List<BodyComponent>? bodyComponents,
    List<Tag>? tags,
  }) {
    return CreateArticleEntity(
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      imageUrl: imageUrl ?? this.imageUrl,
      publishedDate: publishedDate ?? this.publishedDate,
      bodyComponents: bodyComponents ?? this.bodyComponents,
      tags: tags ?? this.tags,
    );
  }
}