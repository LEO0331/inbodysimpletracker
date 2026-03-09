import 'package:flutter/material.dart';
import '../../data/models/inbody_report.dart';

class ReportCard extends StatelessWidget {
  final InbodyReport report;

  const ReportCard({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Report date
            Text(
              "📅 ${report.reportDate.toLocal().toString().split(' ')[0]}",
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
              ),
            ),
            const SizedBox(height: 8),

            // Metrics
            _metricRow("⚖️ Weight", "${report.weight} kg", Colors.blue),
            _metricRow("🔥 Body Fat", "${report.bodyFatPercent} %", Colors.red),
            _metricRow("💪 Muscle Mass", "${report.muscleMass} kg", Colors.green),
            _metricRow("🫀 Visceral Fat", "${report.visceralFat}", Colors.orange),

            const Divider(height: 20),

            // Brief summary suggestion
            Text(
              _generateSummary(),
              style: const TextStyle(fontSize: 13, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }

  Widget _metricRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 14)),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  String _generateSummary() {
    if (report.bodyFatPercent > 25) {
      return "⚠️ Your body fat is above average. Consider focusing on cardio and balanced nutrition.";
    } else if (report.muscleMass > 30) {
      return "💪 Great muscle mass! Keep up strength training and protein intake.";
    } else {
      return "✅ Stable condition. Maintain consistent exercise and diet.";
    }
  }
}
