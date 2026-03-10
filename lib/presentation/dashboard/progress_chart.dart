import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../data/models/inbody_report.dart';

class InbodyChart extends StatelessWidget {
  final List<InbodyReport> reports;
  final String metric; // "weight", "bodyFatPercent", "muscleMass", "all"
  final bool isFullAnalysis; // 是否為全螢幕分析模式（顯示圖例）
  final double? targetWeight; // ✅ 新增：目標體重數值

  const InbodyChart({
    super.key,
    required this.reports,
    this.metric = "weight",
    this.isFullAnalysis = false,
    this.targetWeight, // ✅ 接收目標體重
  });

  @override
  Widget build(BuildContext context) {
    if (reports.isEmpty) return const Center(child: Text("No data available"));

    // 1. 準備數據點
    final List<LineChartBarData> lines = [];
    
    if (metric == "all" || isFullAnalysis) {
      lines.add(_buildLineData(_getSpots("weight"), Colors.blue));
      lines.add(_buildLineData(_getSpots("bodyFatPercent"), Colors.orange));
      lines.add(_buildLineData(_getSpots("muscleMass"), Colors.green));
    } else {
      lines.add(_buildLineData(_getSpots(metric), _getMetricColor(metric), showArea: true));
    }

    // 2. 計算 Y 軸範圍
    double minY = double.infinity;
    double maxY = double.negativeInfinity;
    for (var line in lines) {
      for (var spot in line.spots) {
        if (spot.y < minY) minY = spot.y;
        if (spot.y > maxY) maxY = spot.y;
      }
    }

    // ✅ 如果有目標體重，且正在顯示體重指標，將目標值納入 Y 軸範圍計算
    if (metric == "weight" && targetWeight != null) {
      if (targetWeight! < minY) minY = targetWeight!;
      if (targetWeight! > maxY) maxY = targetWeight!;
    }

    double padding = (maxY - minY) * 0.2; // 稍微增加 padding 讓紅線標籤有空間
    if (padding == 0) padding = 5.0;

    return Column(
      children: [
        if (isFullAnalysis) _buildLegend(),
        
        Expanded(
          child: LineChart(
            LineChartData(
              minY: minY - padding,
              maxY: maxY + padding,
              gridData: const FlGridData(show: false),
              borderData: FlBorderData(
                show: true,
                border: Border(
                  bottom: BorderSide(color: Colors.grey.shade300),
                  left: BorderSide(color: Colors.grey.shade300),
                ),
              ),
              // ✅ 加入目標紅線 (ExtraLinesData)
              extraLinesData: ExtraLinesData(
                horizontalLines: [
                  if (metric == "weight" && targetWeight != null)
                    HorizontalLine(
                      y: targetWeight!,
                      color: Colors.red.withOpacity(0.7),
                      strokeWidth: 2,
                      dashArray: [5, 5], // 虛線設定
                      label: HorizontalLineLabel(
                        show: true,
                        alignment: Alignment.topRight,
                        labelResolver: (line) => 'Goal: ${line.y}kg',
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ),
                ],
              ),
              lineTouchData: _buildTouchData(),
              titlesData: _buildTitlesData(),
              lineBarsData: lines,
            ),
          ),
        ),
      ],
    );
  }

  // 以下輔助方法與您原本的邏輯相同，維持不變
  List<FlSpot> _getSpots(String m) {
    return List.generate(reports.length, (i) {
      final r = reports[i];
      double val = 0;
      if (m == "weight") val = r.weight;
      else if (m == "bodyFatPercent") val = r.bodyFatPercent;
      else if (m == "muscleMass") val = r.muscleMass;
      else if (m == "visceralFat") val = r.visceralFat;
      return FlSpot(i.toDouble(), val);
    });
  }

  LineChartBarData _buildLineData(List<FlSpot> spots, Color color, {bool showArea = false}) {
    return LineChartBarData(
      spots: spots,
      isCurved: true,
      color: color,
      barWidth: 3,
      dotData: const FlDotData(show: true),
      belowBarData: BarAreaData(
        show: showArea,
        color: color.withOpacity(0.1),
      ),
    );
  }

  LineTouchData _buildTouchData() {
    return LineTouchData(
      touchTooltipData: LineTouchTooltipData(
        getTooltipColor: (spot) => Colors.blueGrey.withOpacity(0.9),
        getTooltipItems: (touchedSpots) {
          return touchedSpots.map((barSpot) {
            final titles = ["Weight", "Fat %", "Muscle"];
            final unit = barSpot.barIndex == 1 ? "%" : "kg";
            String label = isFullAnalysis ? titles[barSpot.barIndex] : metric;
            return LineTooltipItem(
              '$label: ${barSpot.y}$unit',
              const TextStyle(color: Colors.white, fontSize: 12),
            );
          }).toList();
        },
      ),
    );
  }

  FlTitlesData _buildTitlesData() {
    return FlTitlesData(
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 30,
          getTitlesWidget: (value, meta) {
            final index = value.toInt();
            if (index >= 0 && index < reports.length && value == index.toDouble()) {
              if (reports.length > 6 && index % (reports.length ~/ 3) != 0) return const SizedBox();
              final date = reports[index].reportDate;
              return Text("${date.month}/${date.day}", style: const TextStyle(fontSize: 10, color: Colors.grey));
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildLegend() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Wrap(
        spacing: 16,
        children: [
          _legendItem("Weight", Colors.blue),
          _legendItem("Fat %", Colors.orange),
          _legendItem("Muscle", Colors.green),
        ],
      ),
    );
  }

  Widget _legendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Color _getMetricColor(String m) {
    if (m == "bodyFatPercent") return Colors.orange;
    if (m == "muscleMass") return Colors.green;
    return Colors.blue;
  }
}
