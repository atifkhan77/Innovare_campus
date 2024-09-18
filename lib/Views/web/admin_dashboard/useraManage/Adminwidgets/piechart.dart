import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // For the Pie Chart

class CustomPieChart extends StatelessWidget {
  final Map<String, int> regNoCounts;

  CustomPieChart({required this.regNoCounts});

  @override
  Widget build(BuildContext context) {
    if (regNoCounts.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }

    return PieChart(
      PieChartData(
        sections: _showingSections(),
        centerSpaceRadius: 0, // Remove hollow center
        borderData: FlBorderData(show: false),
        sectionsSpace: 2,
      ),
    );
  }

  List<PieChartSectionData> _showingSections() {
    if (regNoCounts.isEmpty) return [];

    final List<Color> sectionColors = Colors.primaries; // List of colors
    final totalUsers = regNoCounts.values.reduce((a, b) => a + b);

    return regNoCounts.entries.map((entry) {
      final percentage = (entry.value / totalUsers) * 100;
      final colorIndex = regNoCounts.keys.toList().indexOf(entry.key) %
          sectionColors.length; // Cycle through colors
      return PieChartSectionData(
        color: sectionColors[colorIndex], // Assign different colors to sections
        value: percentage,
        title: '${entry.key}: ${entry.value}',
        radius: 100,
        titleStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        titlePositionPercentageOffset:
            1.4, // Position the title outside the pie
      );
    }).toList();
  }
}
