import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard")),
      body: ListView.builder(
        itemCount: reportProvider.reports.length,
        itemBuilder: (context, i) {
          final report = reportProvider.reports[i];
          return ListTile(
            title: Text("Report: ${report.reportDate.toLocal()}"),
            subtitle: Text("Weight: ${report.weight} kg, Body Fat: ${report.bodyFatPercent}%"),
          );
        },
      ),
    );
  }
}
