import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:journal/data/tag/tag_repository.dart';
import 'package:journal/presentations/article/create/sandbox/chart/chart_page.dart';
import 'package:journal/presentations/article/details/article_details_provider.dart';

final class DraftArticle {
  final int id;
  final List<ArticleAuthors> authors;
  final String title;
  final String subtitle;
  final List<BodyComponent> body;
  final List<Tag> tags;
  final int createdDate;
  final int lastUpdatedDate;

  const DraftArticle({
    required this.id,
    required this.authors,
    required this.title,
    required this.subtitle,
    required this.body,
    required this.tags,
    required this.createdDate,
    required this.lastUpdatedDate,
  });

  DraftArticle copyWith({
    int? id,
    List<ArticleAuthors>? authors,
    String? title,
    String? subtitle,
    List<BodyComponent>? body,
    List<Tag>? tags,
    int? createdDate,
    int? lastUpdatedDate,
  }) {
    return DraftArticle(
      id: id ?? this.id,
      authors: authors ?? this.authors,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      body: body ?? this.body,
      tags: tags ?? this.tags,
      createdDate: createdDate ?? this.createdDate,
      lastUpdatedDate: lastUpdatedDate ?? this.lastUpdatedDate,
    );
  }

  @override
  String toString() {
    return 'DraftArticle{\n'
        'id: $id\n, '
        'authorId: $authors\n, '
        'title: $title\n, '
        'subtitle: $subtitle\n, '
        'body: $body\n, '
        'tags: $tags\n, '
        'createdDate: $createdDate\n, '
        'lastUpdatedDate: $lastUpdatedDate\n'
        '}';
  }
}

sealed class BodyComponent {
  final int order;

  const BodyComponent({required this.order});

  Map<String, dynamic> toMap();

  static BodyComponent fromMap(dynamic json) {
    if (json is String) {
      try {
        json = jsonDecode(json) as Map<String, dynamic>;
      } catch (e) {
        throw FormatException('Invalid JSON string: $e');
      }
    }

    if (json is! Map<String, dynamic>) {
      throw ArgumentError('Expected Map<String, dynamic> or JSON string');
    }

    switch (json['classType']) {
      case 'text':
        return TextBodyComponent.fromMap(json);
      case 'image':
        return ImageBodyComponent.fromMap(json);
      case 'chart':
        return ChartBodyComponent.fromMap(json);
      default:
        throw Exception('Unknown type: ${json['classType']}');
    }
  }
}

class TextBodyComponent extends BodyComponent {
  final String text;

  const TextBodyComponent({required super.order, required this.text});

  @override
  Map<String, dynamic> toMap() {
    return {'classType': 'text', 'order': order, 'text': text};
  }

  factory TextBodyComponent.fromMap(Map<String, dynamic> map) {
    return TextBodyComponent(order: map['order'], text: map['text'] as String);
  }
}

class ImageBodyComponent extends BodyComponent {
  final String description;
  final Uint8List imageBytes;

  const ImageBodyComponent({
    required super.order,
    required this.description,
    required this.imageBytes,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'classType': 'image',
      'order': order,
      'description': description,
      'imageBytes': imageBytes,
    };
  }

  factory ImageBodyComponent.fromMap(Map<String, dynamic> map) {
    return ImageBodyComponent(
      order: map['order'] as int,
      description: map['description'] as String,
      imageBytes: _parseImageBytes(map['imageBytes']),
    );
  }

  // Метод для обработки imageBytes
  static Uint8List _parseImageBytes(dynamic imageBytes) {
    if (imageBytes is List<dynamic>) {
      // Преобразуем список в Uint8List
      return Uint8List.fromList(List<int>.from(imageBytes));
    } else {
      throw FormatException('Invalid format for imageBytes');
    }
  }
}

class ChartBodyComponent extends BodyComponent {
  final List<ChartPoint> points;
  final String title;
  final ChartType chartType;

  const ChartBodyComponent({
    required super.order,
    required this.points,
    required this.title,
    required this.chartType,
  });

  ChartBodyComponent copyWith({
    int? order,
    List<ChartPoint>? points,
    String? title,
    ChartType? chartType,
  }) {
    return ChartBodyComponent(
      order: order ?? this.order,
      points: points ?? this.points,
      title: title ?? this.title,
      chartType: chartType ?? this.chartType,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'classType': 'chart',
      'order': order,
      'points': points.map((p) => p.toMap()).toList(),
      'title': title,
      'chartType': chartType.name,
    };
  }

  factory ChartBodyComponent.fromMap(Map<String, dynamic> map) {
    return ChartBodyComponent(
      order: map['order'] as int,
      points:
          (map['points'] as List).map((p) => ChartPoint.fromMap(p)).toList(),
      title: map['title'] as String,
      chartType: ChartType.values.byName(map['chartType']),
    );
  }
}

class ChartPoint {
  final double x;
  final double y;
  final String label;
  final Color color;

  const ChartPoint({
    required this.x,
    required this.label,
    required this.y,
    required this.color,
  });

  ChartPoint copyWith({double? x, double? y, Color? color, String? label}) {
    return ChartPoint(
      x: x ?? this.x,
      y: y ?? this.y,
      color: color ?? this.color,
      label: label ?? this.label,
    );
  }

  Map<String, dynamic> toMap() {
    return {'x': x, 'y': y, 'label': label, 'color': color.value};
  }

  factory ChartPoint.fromMap(Map<String, dynamic> map) {
    return ChartPoint(
      x: map['x'].toDouble(),
      y: map['y'].toDouble(),
      label: map['label'],
      color: Color(map['color']),
    );
  }
}
