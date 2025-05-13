import 'package:extended_text_field/extended_text_field.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:journal/di/data_di.dart';
import 'package:journal/di/domain_di.dart';
import 'package:journal/presentations/article/create/sandbox/ui_body_component.dart';
import 'package:journal/presentations/routes.dart';
import 'package:journal/presentations/widgets/app_scaffold.dart';
import 'package:provider/provider.dart';

import 'article_create_sandbox_provider.dart';
import 'chart/chart_page.dart';

final class ArticleCreateSandboxPage extends StatelessWidget {
  final int draftArticleId;

  const ArticleCreateSandboxPage({super.key, required this.draftArticleId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create:
          (_) => ArticleCreateSandboxProvider(
            userSettings: DomainDi().userSettings,
            draftArticlesRepository: DataDi().draftArticleRepository,
          )..initialize(draftArticleId),
      child: AppScaffold(body: const _ArticleCreateSandboxBody()),
    );
  }
}

final class _ArticleCreateSandboxAppBar extends StatelessWidget {
  final void Function() onBackPressed;
  final void Function() parameterOnPressed;
  final void Function() onMorePressed;

  const _ArticleCreateSandboxAppBar({
    required this.onBackPressed,
    required this.parameterOnPressed,
    required this.onMorePressed,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      elevation: 5.0,
      floating: false,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: onBackPressed,
      ),
      actions: <Widget>[
        TextButton(
          onPressed: parameterOnPressed,
          child: Text(
            "Перейти к параметрам",
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        IconButton(icon: Icon(Icons.more_vert), onPressed: onMorePressed),
      ],
    );
  }
}

final class _ArticleCreateSandboxBody extends StatelessWidget {
  const _ArticleCreateSandboxBody();

  @override
  Widget build(BuildContext context) {
    return Consumer<ArticleCreateSandboxProvider>(
      builder: (context, provider, _) {
        final snackBarMessage = provider.showSnackBarEvent?.value;
        if (snackBarMessage != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(snackBarMessage),
                duration: Duration(seconds: 1),
              ),
            );
          });
        }

        final draftId = provider.navigateToParametersEvent?.value;
        if (draftId != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacementNamed(
              context,
              Routes.articleCreateParameter,
              arguments: draftId,
            );
          });
        }

        onSavePressed() {
          provider.saveDraft();

          Navigator.pushReplacementNamed(context, Routes.home);
        }

        onBackPressed() {
          Navigator.pushReplacementNamed(context, Routes.home);
        }

        onPopHandler() {
          _showExitDialog(
            context,
            onSavePressed: onSavePressed,
            onBackPressed: onBackPressed,
          );
        }

        onParameterPressed() {
          provider.navigateToParameters();
        }

        onMorePressed() {
          showMenu(
            context: context,
            position: RelativeRect.fromLTRB(
              MediaQuery.of(context).size.width,
              kToolbarHeight,
              0,
              0,
            ),
            items: [
              PopupMenuItem(
                onTap: () {
                  provider.saveDraft();
                },
                child: Text('Сохранить'),
              ),
              PopupMenuItem(
                onTap: () {
                  provider.fixText();
                },
                child: Text('Исправить текст'),
              ),
              PopupMenuItem(
                onTap: () {
                  onParameterPressed();
                },
                child: Text('Параметры'),
              ),
            ],
          );
        }

        final bottomInset = MediaQuery.of(context).viewInsets.bottom;

        return Stack(
          children: [
            PopScope(
              canPop: false,
              onPopInvokedWithResult: (didPop, _) {
                onPopHandler();
              },
              child: CustomScrollView(
                slivers: [
                  _ArticleCreateSandboxAppBar(
                    onBackPressed: onPopHandler,
                    parameterOnPressed: onParameterPressed,
                    onMorePressed: onMorePressed,
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: 16.0,
                        left: 16.0,
                        right: 16.0,
                        bottom: bottomInset + 64,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            controller: provider.titleController,
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 0,
                              ),
                              hintText: 'Заголовок статьи',
                              hintStyle: TextStyle(color: Colors.grey[400]),
                              border: InputBorder.none,
                            ),
                            style: Theme.of(context).textTheme.headlineMedium,
                            maxLines: 1,
                          ),
                          const SizedBox(height: 16),
                          ...provider.bodyComponents.map((component) {
                            return UiBodyComponentWidget(component: component);
                          }),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (provider.showLoadingEvent?.value == true)
              Container(
                color: Colors.black.withValues(alpha: 0.5),
                child: const Center(child: CircularProgressIndicator()),
              ),

            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        provider.addNewTextField();
                      },
                      icon: Icon(Icons.text_fields, color: Colors.blue),
                    ),
                    IconButton(
                      onPressed: () {
                        provider.addNewImage();
                      },
                      icon: Icon(Icons.image, color: Colors.blue),
                    ),
                    IconButton(
                      onPressed: () {
                        provider.addCode();
                      },
                      icon: Icon(Icons.code, color: Colors.blue),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => ChartPage(sandboxProvider: provider),
                          ),
                        );
                      },
                      icon: Icon(Icons.add_chart, color: Colors.blue),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

final class _CustomSpecialTextSpanBuilder extends SpecialTextSpanBuilder {
  @override
  TextSpan build(String data, {TextStyle? textStyle, onTap}) {
    final textSpan = super.build(data, textStyle: textStyle, onTap: onTap);
    return textSpan;
  }

  @override
  SpecialText? createSpecialText(
    String flag, {
    TextStyle? textStyle,
    SpecialTextGestureTapCallback? onTap,
    required int index,
  }) {
    if (flag == '') {
      return null;
    }

    if (flag == BoldSpecialText.flag) {
      return BoldSpecialText(textStyle: textStyle, onTap: onTap, start: index);
    }

    if (flag == CodeSpecialText.flag) {
      return CodeSpecialText(textStyle, onTap, start: index);
    }

    return null;
  }
}

class CodeSpecialText extends SpecialText {
  static const String flag = '```';
  final int start;

  CodeSpecialText(
    TextStyle? textStyle,
    SpecialTextGestureTapCallback? onTap, {
    required this.start,
  }) : super(flag, flag, textStyle);

  @override
  InlineSpan finishText() {
    final String code = toString().replaceAll(flag, '');
    final List<InlineSpan> children = [];

    final keywords = [
      'class',
      'int',
      'String',
      'if',
      'else',
      'return',
      'for',
      'while',
      'bool',
      'Future',
    ];
    final classNamePattern = RegExp(r'\b[A-Z][a-zA-Z0-9_]*\b');
    final bracketPattern = RegExp(r'[\(\)\{\}\[\]]');
    final words = code.split(RegExp(r'(\s+|\b)'));

    for (final word in words) {
      TextStyle style = (textStyle ?? const TextStyle()).copyWith(
        fontFamily: 'monospace',
        color: Colors.black,
      );

      if (keywords.contains(word)) {
        style = style.copyWith(color: Colors.blue, fontWeight: FontWeight.bold);
      } else if (classNamePattern.hasMatch(word)) {
        style = style.copyWith(color: Colors.teal, fontWeight: FontWeight.w600);
      } else if (bracketPattern.hasMatch(word)) {
        style = style.copyWith(
          color: Colors.orange,
          fontWeight: FontWeight.bold,
        );
      }

      children.add(TextSpan(text: word, style: style));
    }

    return TextSpan(children: children);
  }
}

class BoldSpecialText extends SpecialText {
  static const String flag = '**';
  final int start;

  BoldSpecialText({
    TextStyle? textStyle,
    required this.start,
    SpecialTextGestureTapCallback? onTap,
  }) : super(flag, flag, textStyle, onTap: onTap);

  @override
  InlineSpan finishText() {
    final String content = toString().replaceAll(flag, '');
    return TextSpan(
      text: content,
      style: textStyle?.copyWith(
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }
}

Future<void> _showExitDialog(
  BuildContext context, {
  required void Function() onSavePressed,
  required void Function() onBackPressed,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder:
        (context) => AlertDialog(
          title: const Text('Сохранить черновик?'),
          content: const Text('Вы хотите сохранить изменения перед выходом?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(
                'Сохранить и выйти',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(
                'Выйти без сохранения',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
          ],
        ),
  );

  if (result == null) return;

  if (result) {
    onSavePressed();
  } else {
    onBackPressed();
  }
}

final class UiBodyComponentWidget extends StatelessWidget {
  final UiBodyComponent component;

  const UiBodyComponentWidget({super.key, required this.component});

  @override
  Widget build(BuildContext context) {
    switch (component) {
      case UiTextBodyComponent():
        return UiTextBodyComponentWidget(
          component: component as UiTextBodyComponent,
        );
      case UiImageBodyComponent():
        return UiImageBodyComponentWidget(
          component: component as UiImageBodyComponent,
        );
      case UiChartBodyComponent():
        return UiChartBodyComponentWidget(
          component: component as UiChartBodyComponent,
        );
      case UiCodeBodyComponent():
        return UiCodeBodyComponentWidget(
          component: component as UiCodeBodyComponent,
        );
    }
  }
}

final class UiTextBodyComponentWidget extends StatelessWidget {
  final UiTextBodyComponent component;

  const UiTextBodyComponentWidget({super.key, required this.component});

  @override
  Widget build(BuildContext context) {
    return ExtendedTextField(
      cursorColor: Colors.black,
      // cur
      controller: component.controller,
      // focusNode: component.focusNode,
      specialTextSpanBuilder: _CustomSpecialTextSpanBuilder(),
      decoration: InputDecoration(
        hintText: 'Введите текст...',
        hintStyle: TextStyle(color: Colors.grey[400]),
        border: InputBorder.none,
      ),
      style: Theme.of(context).textTheme.bodyLarge,
      maxLines: null,
      textInputAction: TextInputAction.done,
      onSubmitted: (_) {
        final provider = context.read<ArticleCreateSandboxProvider>();
        provider.addNewTextField();
      },
      onChanged: (text) {
        final provider = context.read<ArticleCreateSandboxProvider>();
        provider.handleTextChange(component.order, text);
      },
    );
  }
}

final class UiImageBodyComponentWidget extends StatelessWidget {
  final UiImageBodyComponent component;

  const UiImageBodyComponentWidget({super.key, required this.component});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.memory(
                component.imageBytes,
                fit: BoxFit.cover,
                height: 500,
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 30,
                width: 300,
                child: TextField(
                  controller: component.descriptionController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    hintText: 'Описание изображения...',
                    hintStyle: TextStyle(color: Colors.grey[500]),
                    border: InputBorder.none,
                  ),
                  maxLines: 2,
                ),
              ),
            ],
          ),
        ),

        Positioned(
          top: -12,
          right: -12,
          child: IconButton(
            icon: const Icon(Icons.delete_forever, color: Colors.red, size: 32),
            onPressed: () {
              context
                  .read<ArticleCreateSandboxProvider>()
                  .removeComponentByOrder(component.order);
            },
          ),
        ),
      ],
    );
  }
}

final class UiChartBodyComponentWidget extends StatelessWidget {
  final UiChartBodyComponent component;

  const UiChartBodyComponentWidget({super.key, required this.component});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 300, width: 300, child: _buildChart()),
          const SizedBox(height: 10),
          Text(component.title, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }

  Widget _buildChart() {
    switch (component.type) {
      case ChartType.line:
        return LineChart(
          LineChartData(
            lineBarsData: [
              LineChartBarData(
                spots: component.points.map((e) => FlSpot(e.x, e.y)).toList(),
                isCurved: true,
                barWidth: 3,
              ),
            ],
          ),
        );

      case ChartType.bar:
        return BarChart(
          BarChartData(
            barGroups:
                component.points.map((e) {
                  return BarChartGroupData(
                    x: e.x.toInt(),
                    barRods: [
                      BarChartRodData(toY: e.y, color: e.color, width: 15),
                    ],
                  );
                }).toList(),
          ),
        );

      case ChartType.pie:
        return PieChart(
          PieChartData(
            sections:
                component.points.map((e) {
                  return PieChartSectionData(
                    value: e.y,
                    color: e.color,
                    title:
                        e.labelController.text.isEmpty
                            ? e.y.toStringAsFixed(1)
                            : e.labelController.text,
                    titleStyle: const TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                    ),
                  );
                }).toList(),
          ),
        );
    }
  }
}

final class UiCodeBodyComponentWidget extends StatelessWidget {
  final UiCodeBodyComponent component;

  const UiCodeBodyComponentWidget({super.key, required this.component});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ExtendedTextField(
        controller: component.controller,
        maxLines: null,
        cursorColor: Colors.white,
        style: const TextStyle(
          fontFamily: 'monospace',
          fontSize: 14,
          color: Colors.white,
        ),
        decoration: InputDecoration.collapsed(
          hintText: 'Введите код...',
          hintStyle: TextStyle(color: Colors.grey.shade500),
        ),
        keyboardType: TextInputType.multiline,
        textInputAction: TextInputAction.newline,
        specialTextSpanBuilder: _CodeSpecialTextSpanBuilder(),
        onChanged: (text) {
          context.read<ArticleCreateSandboxProvider>().handleCodeChange(text, component.controller);
        },
        onSubmitted: (_) {
          context.read<ArticleCreateSandboxProvider>().addNewTextField();
        },
        onEditingComplete: () {
          context.read<ArticleCreateSandboxProvider>().handleCodeChange(component.controller.text, component.controller);
        },
      ),
    );
  }
}

class _CodeSpecialTextSpanBuilder extends SpecialTextSpanBuilder {
  @override
  TextSpan build(String data, {TextStyle? textStyle, onTap}) {
    final List<InlineSpan> children = [];

    final RegExp pattern = RegExp(
      r'''//.*?$|"(?:\\.|[^"\\])*"|'(?:\\.|[^'\\])*'|\b(?:if|else|for|while|return|class|final|const|var|void|int|double|String|bool|true|false|null|import|package)\b''',
      multiLine: true,
    );

    int start = 0;

    final matches = pattern.allMatches(data);
    for (final match in matches) {
      if (match.start > start) {
        children.add(
          TextSpan(text: data.substring(start, match.start), style: textStyle),
        );
      }

      final matchText = match.group(0)!;

      TextStyle style = textStyle!;
      if (matchText.startsWith('//')) {
        style = style.copyWith(color: Colors.green);
      } else if (matchText.startsWith('"') || matchText.startsWith("'")) {
        style = style.copyWith(color: Colors.orange);
      } else {
        style = style.copyWith(
          color: Colors.blueAccent,
          fontWeight: FontWeight.bold,
        );
      }

      children.add(TextSpan(text: matchText, style: style));
      start = match.end;
    }

    if (start < data.length) {
      children.add(TextSpan(text: data.substring(start), style: textStyle));
    }

    return TextSpan(children: children, style: textStyle);
  }

  @override
  SpecialText? createSpecialText(
    String flag, {
    TextStyle? textStyle,
    SpecialTextGestureTapCallback? onTap,
    required int index,
  }) {
    return null;
  }
}
