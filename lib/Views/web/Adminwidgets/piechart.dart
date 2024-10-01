import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class CustomDonutChart extends StatelessWidget {
  final Map<String, int> regNoCounts;

  CustomDonutChart({required this.regNoCounts});

  @override
  Widget build(BuildContext context) {
    if (regNoCounts.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }

    return PieChart(
      PieChartData(
        sections: _showingSections(),
        centerSpaceRadius: 30,
        borderData: FlBorderData(show: false),
        sectionsSpace: 2,
      ),
    );
  }

  List<PieChartSectionData> _showingSections() {
    if (regNoCounts.isEmpty) return [];

    final List<Color> sectionColors = Colors.primaries;
    final totalUsers = regNoCounts.values.reduce((a, b) => a + b);

    return regNoCounts.entries.map((entry) {
      final percentage = (entry.value / totalUsers) * 100;
      final colorIndex =
          regNoCounts.keys.toList().indexOf(entry.key) % sectionColors.length;

      return PieChartSectionData(
        color: sectionColors[colorIndex],
        value: entry.value.toDouble(),
        title: '${entry.key}: ${percentage.toStringAsFixed(1)}%',
        radius: 70,
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        titlePositionPercentageOffset: 1.6,
      );
    }).toList();
  }
}
