import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:inbodysimpletracker/presentation/dashboard/report_card.dart';
import 'package:inbodysimpletracker/presentation/dashboard/progress_chart.dart';

import '../../logic/providers/auth_provider.dart';
import '../../logic/providers/report_provider.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final reportProvider = Provider.of<ReportProvider>(context);

    if (auth.user != null) {
      reportProvider.listenReports(auth.user!.uid);
    }

    final reports = reportProvider.reports;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Provider.of<AuthProvider>(context, listen: false).logout();
            },
          )
        ],
      ),
      body: reports.isEmpty
          ? const Center(child: Text("No reports yet"))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Charts section
                  const Text(
                    "Progress Charts",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  ProgressChart(reports: reports, metric: "weight"),
                  const SizedBox(height: 16),
                  ProgressChart(reports: reports, metric: "bodyFatPercent"),
                  const SizedBox(height: 16),
                  ProgressChart(reports: reports, metric: "muscleMass"),
                  const Divider(height: 32),

                  // Reports list
                  const Text(
                    "Reports",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: reports.length,
                    itemBuilder: (context, i) {
                      return ReportCard(report: reports[i]);
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
