import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; // 確保有導入 intl
import 'dart:developer' as developer;

import '../../logic/providers/auth_provider.dart';
import '../../data/models/inbody_report.dart';
import 'progress_chart.dart';
import 'report_card.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String _selectedMetric = "weight";

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.user;

    if (user == null) {
      return const Scaffold(body: Center(child: Text("Please login")));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("InBody Progress"), elevation: 0),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(user.uid)
            .collection("reports")
            .orderBy("reportDate", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Center(child: Text("Error: ${snapshot.error}"));
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("No data available"));
          }

          final docs = snapshot.data!.docs;
          if (docs.isEmpty) return const Center(child: Text("No reports yet."));

          // ✅ 修正點 1：更安全的資料解析邏輯
          final List<InbodyReport> reports = [];
          for (var doc in docs) {
            try {
              final data = doc.data() as Map<String, dynamic>?;
              if (data != null) {
                reports.add(InbodyReport.fromMap(doc.id, data));
              }
            } catch (e) {
              developer.log("Error parsing doc ${doc.id}", error: e);
            }
          }

          final chartReports = reports.reversed.toList();

          return Column(
            children: [
              // ✅ 修正點 2：重新補回 Summary Cards 並確保 value 絕不為 Null
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildSummaryCard(
                        title: "Total Reports",
                        value: reports.length.toString(),
                        icon: Icons.description,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildSummaryCard(
                        title: "Latest Report",
                        // 使用 ?? 確保轉 String 時不會遇到 Null
                        value: reports.isNotEmpty 
                            ? DateFormat('MMM dd').format(reports.first.reportDate)
                            : "N/A",
                        icon: Icons.calendar_today,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),

              // 指標切換
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildMetricChip("weight", "Weight"),
                      const SizedBox(width: 8),
                      _buildMetricChip("bodyFatPercent", "Body Fat %"),
                      const SizedBox(width: 8),
                      _buildMetricChip("muscleMass", "Muscle"),
                    ],
                  ),
                ),
              ),

              // 圖表
              if (chartReports.isNotEmpty)
                Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 24, 32, 16),
                    child: ProgressChart(
                      reports: chartReports, 
                      metric: _selectedMetric,
                    ),
                  ),
                ),

              const Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Align(
                  alignment: Alignment.centerLeft, 
                  child: Text("History", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
                ),
              ),

              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: reports.length,
                  itemBuilder: (context, index) {
                    return ReportCard(
                      report: reports[index],
                      index: reports.length - index,
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ✅ 修正點 3：確保 SummaryCard 的參數處理強健
  Widget _buildSummaryCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        border: Border.all(color: color.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value, // 此處 value 已經在傳入前保證非 Null
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color),
          ),
          Text(title, style: TextStyle(fontSize: 11, color: Colors.grey[700])),
        ],
      ),
    );
  }

  Widget _buildMetricChip(String metric, String label) {
    return ChoiceChip(
      label: Text(label),
      selected: _selectedMetric == metric,
      onSelected: (bool selected) {
        if (selected) setState(() => _selectedMetric = metric);
      },
    );
  }
}
