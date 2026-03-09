import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'dart:developer' as developer;

import '../../logic/providers/auth_provider.dart';
import '../../data/models/inbody_report.dart';
import 'progress_chart.dart'; // 確保已更新為帶有 targetWeight 的 InbodyChart
import 'report_card.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String _selectedMetric = "weight";
  String _dateFilter = "All"; // ✅ 新增：日期篩選初始值
  final ScrollController _mainScrollController = ScrollController();

  @override
  void dispose() {
    _mainScrollController.dispose();
    super.dispose();
  }

  // 彈出全螢幕分析 (略，維持原本邏輯)
  void _showFullHistoryChart(List<InbodyReport> reports) {
    showDialog(
      context: context,
      builder: (context) => Dialog.fullscreen(
        child: Scaffold(
          appBar: AppBar(title: const Text("Combined Trend Analysis")),
          body: Padding(
            padding: const EdgeInsets.all(32.0),
            child: InbodyChart(
              reports: reports.reversed.toList(),
              isFullAnalysis: true,
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

    if (user == null) return const Scaffold(body: Center(child: Text("Please login")));

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
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());

          final docs = snapshot.data?.docs ?? [];
          if (docs.isEmpty) return const Center(child: Text("No reports yet."));

          // 1. 原始資料解析
          final List<InbodyReport> allReports = [];
          for (var doc in docs) {
            try {
              final data = doc.data() as Map<String, dynamic>?;
              if (data != null) allReports.add(InbodyReport.fromMap(doc.id, data));
            } catch (e) { developer.log("Parsing error", error: e); }
          }

          // 2. ✅ 日期過濾邏輯
          final now = DateTime.now();
          final List<InbodyReport> filteredReports = allReports.where((r) {
            if (_dateFilter == "3 Months") {
              return r.reportDate.isAfter(now.subtract(const Duration(days: 90)));
            } else if (_dateFilter == "6 Months") {
              return r.reportDate.isAfter(now.subtract(const Duration(days: 180)));
            }
            return true; // All
          }).toList();

          final chartReports = filteredReports.reversed.toList();

          return Scrollbar(
            controller: _mainScrollController,
            thumbVisibility: true,
            child: SingleChildScrollView(
              controller: _mainScrollController,
              padding: const EdgeInsets.only(bottom: 40),
              child: Column(
                children: [
                  // Summary Cards...
                  _buildTopSummary(filteredReports),

                  // ✅ 指標切換與日期篩選下拉選單
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // 指標切換 (左側)
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                _buildMetricChip("weight", "Weight"),
                                const SizedBox(width: 8),
                                _buildMetricChip("bodyFatPercent", "Fat %"),
                                const SizedBox(width: 8),
                                _buildMetricChip("muscleMass", "Muscle"),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        // 🗓️ 日期篩選器 (右側)
                        DropdownButton<String>(
                          value: _dateFilter,
                          style: const TextStyle(fontSize: 14, color: Colors.blue, fontWeight: FontWeight.bold),
                          underline: Container(height: 2, color: Colors.blueAccent),
                          items: ["All", "3 Months", "6 Months"].map((String value) {
                            return DropdownMenuItem<String>(value: value, child: Text(value));
                          }).toList(),
                          onChanged: (val) => setState(() => _dateFilter = val!),
                        ),
                      ],
                    ),
                  ),

                  // 圖表區塊
                  if (chartReports.isNotEmpty)
                    Card(
                      margin: const EdgeInsets.all(16),
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 24, 32, 16),
                        child: SizedBox(
                          height: 220,
                          child: InbodyChart(
                            reports: chartReports,
                            metric: _selectedMetric,
                            targetWeight: 70.0, // 👈 ✅ 可以在這裡設定目標體重
                          ),
                        ),
                      ),
                    ),

                  // History List... (使用 filteredReports)
                  _buildHistoryList(filteredReports),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // 輔助方法：頂部總覽 (簡化示範)
  Widget _buildTopSummary(List<InbodyReport> reports) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(child: _buildSummaryCard(title: "Shown Reports", value: reports.length.toString(), icon: Icons.list, color: Colors.blue)),
          const SizedBox(width: 12),
          Expanded(child: _buildSummaryCard(title: "Latest Date", value: reports.isNotEmpty ? DateFormat('MM/dd').format(reports.first.reportDate) : "N/A", icon: Icons.calendar_month, color: Colors.green)),
        ],
      ),
    );
  }

  // 輔助方法：歷史列表
  Widget _buildHistoryList(List<InbodyReport> reports) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("History", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextButton.icon(onPressed: () => _showFullHistoryChart(reports), icon: const Icon(Icons.analytics), label: const Text("Full Analysis")),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: reports.length,
            itemBuilder: (context, index) => ReportCard(report: reports[index], index: reports.length - index),
          ),
        ),
      ],
    );
  }

  // 其餘 _buildSummaryCard, _buildMetricChip 保持不變...
  Widget _buildSummaryCard({required String title, required String value, required IconData icon, required Color color}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 8),
        Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
        Text(title, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ]),
    );
  }

  Widget _buildMetricChip(String metric, String label) {
    return ChoiceChip(
      label: Text(label),
      selected: _selectedMetric == metric,
      onSelected: (val) { if (val) setState(() => _selectedMetric = metric); },
    );
  }
}
