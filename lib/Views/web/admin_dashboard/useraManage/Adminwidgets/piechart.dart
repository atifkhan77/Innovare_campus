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
        borderData:
            FlBorderData(show: false), // Hide borders for a cleaner look
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
        title:
            '${entry.key}: ${percentage.toStringAsFixed(1)}%', // Show both key and percentage
        radius: 110, // Increased radius
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        titlePositionPercentageOffset: 1.3, // Adjust title position
      );
    }).toList();
  }
}
