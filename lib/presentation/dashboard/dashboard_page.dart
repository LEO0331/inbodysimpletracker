import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'dart:developer' as developer;

import '../../logic/providers/auth_provider.dart';
import '../../logic/providers/mqtt_provider.dart'; // ✅ 新增：MQTT Provider
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
  String _dateFilter = "All";
  final ScrollController _mainScrollController = ScrollController();

  @override
  void dispose() {
    _mainScrollController.dispose();
    super.dispose();
  }

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
    // ✅ 監聽 MQTT 狀態與數據
    final mqtt = Provider.of<MqttProvider>(context);
    final user = auth.user;

    if (user == null) return const Scaffold(body: Center(child: Text("Please login")));

    if (!mqtt.isConnected && !mqtt.isLoading) {
      // 建議在微任務中執行，避免在 build 期間呼叫 notifyListeners
      Future.microtask(() => mqtt.initMqtt(user.uid));
    }
    
    return Scaffold(
      appBar: AppBar(
        title: const Text("InBody Dashboard"),
        elevation: 0,
        actions: [
          // ✅ MQTT 連線狀態指示燈
          Row(
            children: [
              Text(
                mqtt.isConnected ? "MQTT Live" : "Offline",
                style: TextStyle(fontSize: 12, color: mqtt.isConnected ? Colors.green : Colors.grey),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.circle,
                color: mqtt.isConnected ? Colors.green : Colors.red,
                size: 12,
              ),
              const SizedBox(width: 16),
            ],
          ),
        ],
      ),
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
          
          // 1. 原始資料解析
          final List<InbodyReport> allReports = [];
          for (var doc in docs) {
            try {
              final data = doc.data() as Map<String, dynamic>?;
              if (data != null) allReports.add(InbodyReport.fromMap(doc.id, data));
            } catch (e) { developer.log("Parsing error", error: e); }
          }

          // 2. 日期過濾邏輯
          final now = DateTime.now();
          final List<InbodyReport> filteredReports = allReports.where((r) {
            if (_dateFilter == "3 Months") {
              return r.reportDate.isAfter(now.subtract(const Duration(days: 90)));
            } else if (_dateFilter == "6 Months") {
              return r.reportDate.isAfter(now.subtract(const Duration(days: 180)));
            }
            return true;
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
                  // ✅ 3. 新增：MQTT 即時數據展示區 (只在有新數據時顯示)
                  if (mqtt.mqttReports.isNotEmpty) _buildMqttLiveSection(mqtt.mqttReports.first),

                  _buildTopSummary(filteredReports),

                  // 指標切換與日期篩選
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
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
                            targetWeight: 70.0,
                          ),
                        ),
                      ),
                    )
                  else if (docs.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Text("No history reports yet."),
                    ),

                  _buildHistoryList(filteredReports),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ✅ 新增：MQTT 即時數據 UI 區塊
  Widget _buildMqttLiveSection(InbodyReport latestReport) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.blue.shade50, Colors.white]),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blueAccent.withOpacity(0.5)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.sensors, color: Colors.blueAccent),
              const SizedBox(width: 8),
              const Text("📡 Live MQTT Data (Recent Scan)", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent)),
              const Spacer(),
              Text(DateFormat('HH:mm:ss').format(latestReport.reportDate), style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildLiveMetric("Weight", "${latestReport.weight} kg"),
              _buildLiveMetric("Fat %", "${latestReport.bodyFatPercent} %"),
              _buildLiveMetric("Muscle", "${latestReport.muscleMass} kg"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLiveMetric(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue)),
      ],
    );
  }

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

  Widget _buildSummaryCard({required String title, required String value, required IconData icon, required Color color}) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: Column(
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricChip(String metric, String label) {
    bool isSelected = _selectedMetric == metric;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (val) { if (val) setState(() => _selectedMetric = metric); },
    );
  }

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
}
