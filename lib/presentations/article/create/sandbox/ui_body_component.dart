import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:journal/presentations/article/create/sandbox/chart/chart_page.dart';

sealed class UiBodyComponent {
  final int order;

  const UiBodyComponent({required this.order});

  void dispose() {}
}

class UiTextBodyComponent extends UiBodyComponent {
  final TextEditingController controller;
  final FocusNode focusNode;

  const UiTextBodyComponent({
    required super.order,
    required this.controller,
    required this.focusNode,
  });

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }
}

class UiImageBodyComponent extends UiBodyComponent {
  final TextEditingController descriptionController;
  final Uint8List imageBytes;

  UiImageBodyComponent({
    required super.order,
    required this.descriptionController,
    required this.imageBytes,
  });

  UiImageBodyComponent copyWith({
    int? order,
    Uint8List? imageBytes,
    TextEditingController? descriptionController,
  }) {
    return UiImageBodyComponent(
      order: order ?? this.order,
      imageBytes: imageBytes ?? this.imageBytes,
      descriptionController:
          descriptionController ?? this.descriptionController,
    );
  }

  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }
}

class UiChartBodyComponent extends UiBodyComponent {
  final List<UiChartPoint> points;
  final String title;
  final ChartType type;

  const UiChartBodyComponent({
    required super.order,
    required this.points,
    required this.title,
    required this.type,
  });

  UiChartBodyComponent copyWith({
    int? order,
    List<UiChartPoint>? points,
    String? title,
    ChartType? type,
  }) {
    return UiChartBodyComponent(
      order: order ?? this.order,
      points: points ?? this.points,
      title: title ?? this.title,
      type: type ?? this.type,
    );
  }
}

class UiCodeBodyComponent extends UiBodyComponent {
  final TextEditingController controller;

  const UiCodeBodyComponent({required super.order, required this.controller});

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

final class UiChartPoint {
  final double x;
  final double y;
  final TextEditingController labelController;
  final Color color;

  const UiChartPoint({
    required this.x,
    required this.labelController,
    required this.y,
    required this.color,
  });

  UiChartPoint copyWith({
    double? x,
    double? y,
    Color? color,
    TextEditingController? labelController,
  }) {
    return UiChartPoint(
      x: x ?? this.x,
      y: y ?? this.y,
      color: color ?? this.color,
      labelController: labelController ?? this.labelController,
    );
  }
}
