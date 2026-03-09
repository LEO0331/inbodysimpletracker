import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../logic/providers/auth_provider.dart';
import '../../data/models/inbody_report.dart';

class ReportCard extends StatelessWidget {
  final InbodyReport report;
  final int index;

  const ReportCard({
    super.key,
    required this.report,
    required this.index,
  });

  void _showDeleteDialog(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final user = auth.user;

    // 🛡️ 安全檢查：確保使用者已登入
    if (user == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Report"),
        content: const Text("Are you sure you want to delete this report? This action cannot be undone."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await FirebaseFirestore.instance
                    .collection("users")
                    .doc(user.uid)
                    .collection("reports")
                    .doc(report.id)
                    .delete();

                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Report deleted successfully"),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Error deleting report: $e"),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 🛡️ 安全檢查：確保日期不為 null (雖然 Model 已處理，但多一層保護)
    final String formattedDate = report.reportDate != null 
        ? DateFormat('MMM dd, yyyy').format(report.reportDate)
        : "Unknown Date";

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias, // 讓邊角更圓滑
      child: ExpansionTile(
        backgroundColor: Colors.blue[50]?.withOpacity(0.3),
        leading: CircleAvatar(
          backgroundColor: Colors.blue[100],
          child: Text(
            '$index',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue[700],
            ),
          ),
        ),
        title: Text(
          formattedDate,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          'Weight: ${report.weight?.toStringAsFixed(1) ?? "0.0"} kg',
          style: TextStyle(color: Colors.grey[600], fontSize: 12),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Divider(),
                _buildMetricRow('Weight', '${report.weight ?? 0} kg', Icons.monitor_weight),
                _buildMetricRow('Body Fat %', '${report.bodyFatPercent ?? 0}%', Icons.pie_chart),
                _buildMetricRow('Muscle Mass', '${report.muscleMass ?? 0} kg', Icons.fitness_center),
                _buildMetricRow('Visceral Fat', '${report.visceralFat ?? 0}', Icons.opacity),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => _showDeleteDialog(context),
                    icon: const Icon(Icons.delete, color: Colors.red, size: 18),
                    label: const Text('Delete Report', style: TextStyle(color: Colors.red)),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.red),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricRow(String label, String value, IconData icon) {
    // 🛡️ 確保 value 絕對不是 null，避免 Text 崩潰
    final safeValue = value ?? "N/A";

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.blue[700]),
          const SizedBox(width: 12),
          Expanded(child: Text(label)),
          Text(
            safeValue,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
