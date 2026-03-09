import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../data/models/inbody_report.dart';

class ProgressChart extends StatelessWidget {
  final List<InbodyReport> reports;
  final String metric;

  const ProgressChart({
    super.key,
    required this.reports,
    this.metric = "weight", // 提供預設值防止 Null
  });

  @override
  Widget build(BuildContext context) {
    if (reports.isEmpty) {
      return const Center(child: Text("No data available"));
    }

    final spots = <FlSpot>[];
    for (int i = 0; i < reports.length; i++) {
      final report = reports[i];
      double value;
      switch (metric) {
        case "weight":
          value = report.weight;
          break;
        case "bodyFatPercent":
          value = report.bodyFatPercent;
          break;
        case "muscleMass":
          value = report.muscleMass;
          break;
        default:
          value = 0;
      }
      spots.add(FlSpot(i.toDouble(), value));
    }

    // 💡 自動計算 Y 軸範圍，避免線條看起來像直線
    final allValues = spots.map((s) => s.y).toList();
    double minY = allValues.reduce((a, b) => a < b ? a : b);
    double maxY = allValues.reduce((a, b) => a > b ? a : b);
    double padding = (maxY - minY) * 0.2; // 上下留 20% 空間
    if (padding == 0) padding = 5.0; // 如果數據都一樣，手動拉開

    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          minY: minY - padding,
          maxY: maxY + padding,
          gridData: const FlGridData(show: false), // 隱藏網格讓畫面更乾淨
          borderData: FlBorderData(
            show: true,
            border: Border(
              bottom: BorderSide(color: Colors.grey.shade300, width: 1),
              left: BorderSide(color: Colors.grey.shade300, width: 1),
            ),
          ),
          titlesData: FlTitlesData(
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) => Text(
                  value.toStringAsFixed(1),
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: 1, // 每個點都顯示標籤
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  // 💡 只在整數索引且每隔幾筆顯示一次，避免 Web 上標籤重疊
                  if (index >= 0 && index < reports.length && value == index.toDouble()) {
                    if (reports.length > 6 && index % (reports.length ~/ 4) != 0) {
                      return const SizedBox.shrink();
                    }
                    final date = reports[index].reportDate;
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text("${date.month}/${date.day}", 
                        style: const TextStyle(fontSize: 10, color: Colors.grey)),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: _getMetricColor(), // 根據指標自動換色
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: true),
              belowBarData: BarAreaData(
                show: true,
                color: _getMetricColor().withOpacity(0.1),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getMetricColor() {
    switch (metric) {
      case "weight": return Colors.blue;
      case "bodyFatPercent": return Colors.orange;
      case "muscleMass": return Colors.green;
      default: return Colors.blue;
    }
  }
}
