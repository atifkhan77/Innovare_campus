import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // For the Pie Chart

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
        centerSpaceRadius:
            30, // Adjusted hollow center radius for smaller donut chart
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
        value: entry.value.toDouble(), // Use raw count for value
        title:
            '${entry.key}: ${percentage.toStringAsFixed(1)}%', // Show both key and percentage
        radius: 70, // Reduced radius for a smaller donut chart
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        titlePositionPercentageOffset:
            1.6, // Adjusted title position to avoid overlap
      );
    }).toList();
  }
}
