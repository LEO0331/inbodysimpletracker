import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../data/models/inbody_report.dart';

class ProgressChart extends StatelessWidget {
  final List<InbodyReport> reports;
  final String metric; // "weight", "bodyFatPercent", "muscleMass"

  const ProgressChart({super.key, required this.reports, required this.metric});

  @override
  Widget build(BuildContext context) {
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

    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index >= 0 && index < reports.length) {
                    final date = reports[index].reportDate;
                    return Text("${date.month}/${date.day}", style: const TextStyle(fontSize: 10));
                  }
                  return const Text("");
                },
              ),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: Colors.blue,
              barWidth: 3,
              dotData: FlDotData(show: true),
            ),
          ],
        ),
      ),
    );
  }
}
