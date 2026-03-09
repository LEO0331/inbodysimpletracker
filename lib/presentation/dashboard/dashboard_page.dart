import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'dart:developer' as developer;

import '../../logic/providers/auth_provider.dart';
import '../../data/models/inbody_report.dart';
import 'progress_chart.dart'; // 確保這檔案裡類別名已改為 InbodyChart
import 'report_card.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String _selectedMetric = "weight";
  final ScrollController _mainScrollController = ScrollController();

  @override
  void dispose() {
    _mainScrollController.dispose();
    super.dispose();
  }

  // ✅ 彈出全螢幕「綜合對比圖表」分析
  void _showFullHistoryChart(List<InbodyReport> reports) {
    showDialog(
      context: context,
      builder: (context) => Dialog.fullscreen(
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Combined Trend Analysis"),
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              children: [
                const Text(
                  "Weight vs Fat % vs Muscle Mass",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text("Comprehensive view of your body composition changes",
                    style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 30),
                Expanded(
                  child: InbodyChart(
                    reports: reports.reversed.toList(),
                    isFullAnalysis: true, // ✅ 開啟多線模式
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Tip: Values use different scales. Focus on the slope of each line.",
                  style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.user;

    if (user == null) {
      return const Scaffold(body: Center(child: Text("Please login")));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("InBody Dashboard"), elevation: 0),
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

          final docs = snapshot.data?.docs ?? [];
          if (docs.isEmpty) return _buildEmptyState();

          // 安全解析資料，避免 Null 錯誤
          final List<InbodyReport> reports = [];
          for (var doc in docs) {
            try {
              final data = doc.data() as Map<String, dynamic>?;
              if (data != null) {
                reports.add(InbodyReport.fromMap(doc.id, data));
              }
            } catch (e) {
              developer.log("Corrupt data skipped: ${doc.id}", error: e);
            }
          }

          final chartReports = reports.reversed.toList();

          return Scrollbar(
            controller: _mainScrollController,
            thumbVisibility: true,
            trackVisibility: true,
            thickness: 8,
            child: SingleChildScrollView(
              controller: _mainScrollController,
              padding: const EdgeInsets.only(bottom: 40),
              child: Column(
                children: [
                  // 1. 數據總覽卡片
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildSummaryCard(
                            title: "Total Reports",
                            value: reports.length.toString(),
                            icon: Icons.assignment_outlined,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildSummaryCard(
                            title: "Latest Update",
                            value: reports.isNotEmpty 
                                ? DateFormat('MMM dd').format(reports.first.reportDate)
                                : "N/A",
                            icon: Icons.update,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 2. 指標切換與單線圖表
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
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

                  Card(
                    margin: const EdgeInsets.all(16),
                    elevation: 3,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 24, 32, 16),
                      child: SizedBox(
                        height: 220,
                        child: InbodyChart(
                          reports: chartReports, 
                          metric: _selectedMetric,
                          isFullAnalysis: false, // Dashboard 模式：單線帶陰影
                        ),
                      ),
                    ),
                  ),

                  // 3. 歷史列表標題與分析按鈕
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("History", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        TextButton.icon(
                          onPressed: () => _showFullHistoryChart(reports),
                          icon: const Icon(Icons.insights),
                          label: const Text("Full Analysis"),
                        ),
                      ],
                    ),
                  ),

                  // 4. 歷史列表 (ListView)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(), // 由外層 SingleChildScrollView 捲動
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
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.bar_chart_rounded, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text("No reports yet.", style: TextStyle(fontSize: 18, color: Colors.grey)),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Go back to Upload"),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard({required String title, required String value, required IconData icon, required Color color}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        border: Border.all(color: color.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
          Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildMetricChip(String metric, String label) {
    return ChoiceChip(
      label: Text(label),
      selected: _selectedMetric == metric,
      onSelected: (val) {
        if (val) setState(() => _selectedMetric = metric);
      },
    );
  }
}
