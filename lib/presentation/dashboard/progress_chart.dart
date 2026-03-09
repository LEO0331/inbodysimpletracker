import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../data/models/inbody_report.dart';

class InbodyChart extends StatelessWidget {
  final List<InbodyReport> reports;
  final String metric; // "weight", "bodyFatPercent", "muscleMass", "all"
  final bool isFullAnalysis; // 是否為全螢幕分析模式（顯示圖例）

  const InbodyChart({
    super.key,
    required this.reports,
    this.metric = "weight",
    this.isFullAnalysis = false,
  });

  @override
  Widget build(BuildContext context) {
    if (reports.isEmpty) return const Center(child: Text("No data available"));

    // 1. 準備數據點
    final List<LineChartBarData> lines = [];
    
    if (metric == "all" || isFullAnalysis) {
      // 多線模式
      lines.add(_buildLineData(_getSpots("weight"), Colors.blue));
      lines.add(_buildLineData(_getSpots("bodyFatPercent"), Colors.orange));
      lines.add(_buildLineData(_getSpots("muscleMass"), Colors.green));
    } else {
      // 單線模式 (Dashboard 預設)
      lines.add(_buildLineData(_getSpots(metric), _getMetricColor(metric), showArea: true));
    }

    // 2. 計算 Y 軸範圍 (取得所有線條中的極值)
    double minY = double.infinity;
    double maxY = double.negativeInfinity;
    for (var line in lines) {
      for (var spot in line.spots) {
        if (spot.y < minY) minY = spot.y;
        if (spot.y > maxY) maxY = spot.y;
      }
    }
    double padding = (maxY - minY) * 0.15;
    if (padding == 0) padding = 5.0;

    return Column(
      children: [
        // 如果是全分析模式，顯示圖例
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
              lineTouchData: _buildTouchData(),
              titlesData: _buildTitlesData(),
              lineBarsData: lines,
            ),
          ),
        ),
      ],
    );
  }

  // 取得特定指標的點
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

  // 建立線條樣式
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

  // 觸發點擊提示
  LineTouchData _buildTouchData() {
    return LineTouchData(
      touchTooltipData: LineTouchTooltipData(
        getTooltipColor: (spot) => Colors.blueGrey.withOpacity(0.9),
        getTooltipItems: (touchedSpots) {
          return touchedSpots.map((barSpot) {
            final titles = ["Weight", "Fat %", "Muscle"];
            final unit = barSpot.barIndex == 1 ? "%" : "kg";
            // 如果是單線模式，名稱要對應正確
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

  // 座標軸標籤設定 (相容 Web)
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
