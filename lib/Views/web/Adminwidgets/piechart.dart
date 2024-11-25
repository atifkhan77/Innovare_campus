import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class CustomHistogram extends StatelessWidget {
  final Map<String, int> regNoCounts;

  const CustomHistogram({super.key, required this.regNoCounts});

  @override
  Widget build(BuildContext context) {
    if (regNoCounts.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return BarChart(
      BarChartData(
        barGroups: _buildBarGroups(),
        titlesData: _buildTitlesData(),
        borderData: FlBorderData(
          border: const Border(
            bottom: BorderSide(color: Colors.black),
            left: BorderSide(color: Colors.black),
          ),
        ),
        gridData: FlGridData(show: false),
      ),
    );
  }

  List<BarChartGroupData> _buildBarGroups() {
    const List<Color> barColors = Colors.primaries;
    int index = 0;

    return regNoCounts.entries.map((entry) {
      final color = barColors[index % barColors.length];
      index++;
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: entry.value.toDouble(),
            color: color,
            width: 16,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    }).toList();
  }

  FlTitlesData _buildTitlesData() {
    return FlTitlesData(
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (double value, TitleMeta meta) {
            final index = value.toInt() - 1;
            if (index < 0 || index >= regNoCounts.keys.length) {
              return const SizedBox.shrink();
            }
            final label = regNoCounts.keys.elementAt(index);
            return SideTitleWidget(
              axisSide: meta.axisSide,
              child: Text(label, style: const TextStyle(fontSize: 12)),
            );
          },
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 40,
          getTitlesWidget: (double value, TitleMeta meta) {
            return Text(
              value.toInt().toString(),
              style: const TextStyle(fontSize: 12),
            );
          },
        ),
      ),
      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
    );
  }
}
