import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:journal/presentations/article/create/sandbox/article_create_sandbox_provider.dart';
import 'package:journal/presentations/article/create/sandbox/ui_body_component.dart';
import 'package:provider/provider.dart';

class ChartPage extends StatelessWidget {
  final UiChartBodyComponent? component;
  final ArticleCreateSandboxProvider sandboxProvider;

  const ChartPage({super.key, required this.sandboxProvider, this.component});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ChartProvider(component)),
      ],
      child: ChartView(sandboxProvider: sandboxProvider,),
    );

  }
}

class ChartView extends StatelessWidget {
  final ArticleCreateSandboxProvider sandboxProvider;

  final List<Color> availableColors = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.cyan,
  ];

  ChartView({super.key, required this.sandboxProvider});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ChartProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Создание графика')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: provider.titleController,
              cursorColor:
                  Theme.of(context).colorScheme.onPrimary, // Цвет курсора
              style: TextStyle(
                fontSize: 18,
                color: Colors.black87, // Цвет текста
              ),
              decoration: InputDecoration(
                hintText: 'Название графика',
                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 18),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade400),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              'Настройте данные для графика:',
              style: TextStyle(fontSize: 18),
            ),

            const SizedBox(height: 8),
            _buildSliders(context, provider),

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                provider.addPoint();
              },
              child: Text(
                'Добавить новую точку',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),

            const SizedBox(height: 20),
            const Text('Выберите тип графика:', style: TextStyle(fontSize: 18)),
            const _ChartTypeSelector(),

            const SizedBox(height: 20),
            SizedBox(height: 300, child: _buildChart(provider)),

            SizedBox(height: 100),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(Colors.black),
                ),
                onPressed: () {
                  final points = provider.points;
                  final title = provider.titleController.text;
                  final chartType = provider.chartType;

                  final component = UiChartBodyComponent(order: -1, points: points, title: title, type: chartType);

                  sandboxProvider.addNewGraph(component);

                  Navigator.pop(context);
                },
                child: Text('Сохранить', style: TextStyle(fontSize: 20)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSliders(BuildContext context, ChartProvider provider) {
    if (provider.chartType == ChartType.pie) {
      return _buildPieSliders(context, provider);
    } else {
      return _buildXYSliders(context, provider);
    }
  }

  Widget _buildPieSliders(BuildContext context, ChartProvider provider) {
    return Column(
      children:
          provider.points.asMap().entries.map((entry) {
            final index = entry.key;
            final point = entry.value;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Точка ${index + 1}:',
                  style: const TextStyle(color: Colors.black),
                ),

                _ChartTextField(
                  controller: point.labelController,
                  hintText: 'Название сектора',
                ),

                const SizedBox(height: 8),

                const Text('Значение:', style: TextStyle(color: Colors.black)),
                buildStyledSlider(
                  context: context,
                  value: point.y,
                  min: 1,
                  max: 100,
                  divisions: 99,
                  onChanged: (value) {
                    provider.updatePoint(index, point.copyWith(y: value));
                  },
                ),

                Row(
                  children: [
                    const Text('Цвет:', style: TextStyle(color: Colors.black)),
                    const SizedBox(width: 10),
                    DropdownButton<Color>(
                      value: point.color,
                      onChanged: (Color? newColor) {
                        if (newColor != null) {
                          provider.updatePoint(
                            index,
                            point.copyWith(color: newColor),
                          );
                        }
                      },
                      items:
                          availableColors.map((color) {
                            return DropdownMenuItem(
                              value: color,
                              child: Container(
                                width: 50,
                                height: 20,
                                color: color,
                              ),
                            );
                          }).toList(),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        provider.removePoint(index);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            );
          }).toList(),
    );
  }

  Widget _buildXYSliders(BuildContext context, ChartProvider provider) {
    return Column(
      children:
          provider.points.asMap().entries.map((entry) {
            final index = entry.key;
            final point = entry.value;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Точка ${index + 1}:',
                  style: const TextStyle(color: Colors.black),
                ),

                const Text(
                  'X значение:',
                  style: TextStyle(color: Colors.black),
                ),
                buildStyledSlider(
                  context: context,
                  value: point.x,
                  min: 1,
                  max: 100,
                  divisions: 99,
                  onChanged: (value) {
                    provider.updatePoint(index, point.copyWith(x: value));
                  },
                ),

                const Text(
                  'Y значение:',
                  style: TextStyle(color: Colors.black),
                ),
                buildStyledSlider(
                  context: context,
                  value: point.y,
                  min: 1,
                  max: 100,
                  divisions: 99,
                  onChanged: (value) {
                    provider.updatePoint(index, point.copyWith(y: value));
                  },
                ),

                Row(
                  children: [
                    const Text('Цвет:', style: TextStyle(color: Colors.black)),
                    const SizedBox(width: 10),
                    DropdownButton<Color>(
                      value: point.color,
                      onChanged: (Color? newColor) {
                        if (newColor != null) {
                          provider.updatePoint(
                            index,
                            point.copyWith(color: newColor),
                          );
                        }
                      },
                      items:
                          availableColors.map((color) {
                            return DropdownMenuItem(
                              value: color,
                              child: Container(
                                width: 50,
                                height: 20,
                                color: color,
                              ),
                            );
                          }).toList(),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        provider.removePoint(index);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            );
          }).toList(),
    );
  }

  Widget _buildChart(ChartProvider provider) {
    if (provider.points.isEmpty) {
      return const Center(child: Text('Добавьте точки для построения графика'));
    }

    switch (provider.chartType) {
      case ChartType.line:
        return LineChart(
          LineChartData(
            lineBarsData: [
              LineChartBarData(
                spots: provider.points.map((e) => FlSpot(e.x, e.y)).toList(),
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
                provider.points.map((e) {
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
                provider.points.map((e) {
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

  Widget buildStyledSlider({
    required BuildContext context,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required ValueChanged<double> onChanged,
  }) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        activeTrackColor: Theme.of(context).colorScheme.onPrimary,
        inactiveTrackColor: Colors.grey.shade300,
        thumbColor: Theme.of(context).colorScheme.primary,
        overlayColor: Theme.of(context).colorScheme.onPrimary.withOpacity(0.2),
        valueIndicatorColor: Theme.of(context).colorScheme.onPrimary,
        trackHeight: 4.0,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10.0),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 18.0),
        valueIndicatorTextStyle: const TextStyle(color: Colors.white),
      ),
      child: Slider(
        value: value,
        min: min,
        max: max,
        divisions: divisions,
        label: value.toStringAsFixed(1),
        onChanged: onChanged,
      ),
    );
  }
}

class _ChartTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;

  const _ChartTextField({required this.controller, this.hintText = ''});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      cursorColor: Theme.of(context).colorScheme.onPrimary, // Цвет курсора
      style: TextStyle(
        fontSize: 18,
        color: Colors.black87, // Цвет текста
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 18),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 2,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        filled: true,
        fillColor: Colors.grey.shade100,
      ),
    );
  }
}

class _ChartTypeSelector extends StatelessWidget {
  const _ChartTypeSelector();

  @override
  Widget build(BuildContext context) {
    final _ = Provider.of<ChartProvider>(context);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildRadio(context, ChartType.line, 'Линейный график'),
          _buildRadio(context, ChartType.bar, 'Столбчатая диаграмма'),
          _buildRadio(context, ChartType.pie, 'Круговая диаграмма'),
        ],
      ),
    );
  }

  Widget _buildRadio(BuildContext context, ChartType type, String label) {
    final provider = Provider.of<ChartProvider>(context, listen: false);
    return Row(
      children: [
        Radio<ChartType>(
          activeColor: Colors.black,
          value: type,
          groupValue: provider.chartType,
          onChanged: (newType) {
            provider.changeChartType(newType!);
          },
        ),
        Text(label),
      ],
    );
  }
}

enum ChartType { line, bar, pie }

class ChartProvider extends ChangeNotifier {
  List<UiChartPoint> points = [];
  ChartType chartType = ChartType.line;
  final TextEditingController titleController = TextEditingController();

  ChartProvider(UiChartBodyComponent? component) {
    if (component != null) {
      points = component.points;
      chartType = component.type;
      titleController.text = component.title;
    }
  }

  void addPoint() {
    final point = UiChartPoint(
      x: 1,
      y: 1,
      color: Colors.blue,
      labelController: TextEditingController(
        text: 'Сектор ${points.length + 1}',
      ),
    );
    points.add(point);
    notifyListeners();
  }

  void updatePoint(int index, UiChartPoint point) {
    if (index >= 0 && index < points.length) {
      points[index] = point;
      notifyListeners();
    }
  }

  void removePoint(int index) {
    if (index >= 0 && index < points.length) {
      points.removeAt(index);
      notifyListeners();
    }
  }

  void clearPoints() {
    points.clear();
    notifyListeners();
  }

  void changeChartType(ChartType newType) {
    if (chartType != newType) {
      chartType = newType;
      clearPoints();
      notifyListeners();
    }
  }
}
