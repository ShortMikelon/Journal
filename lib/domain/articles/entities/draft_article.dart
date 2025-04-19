import 'package:journal/data/tag/tag_repository.dart';

final class DraftArticle {
  final int id;
  final int authorId;
  final String title;
  final String subtitle;
  final List<BodyComponent> body;
  final List<Tag> tags;
  final int createdDate;
  final int lastUpdatedDate;

  const DraftArticle({
    required this.id,
    required this.authorId,
    required this.title,
    required this.subtitle,
    required this.body,
    required this.tags,
    required this.createdDate,
    required this.lastUpdatedDate,
  });
}

final class BodyComponent {
  final String text;
  final int order;

  const BodyComponent({
    required this.text,
    required this.order,
  });

  BodyComponent copyWith({
    String? text,
    int? order,
  }) {
    return BodyComponent(
      text: text ?? this.text,
      order: order ?? this.order,
    );
  }
}