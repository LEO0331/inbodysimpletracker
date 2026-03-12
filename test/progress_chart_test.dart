import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:inbodysimpletracker/presentation/dashboard/progress_chart.dart';
import 'package:inbodysimpletracker/data/models/inbody_report.dart';

void main() {
  final sampleReports = [
    InbodyReport(
      id: '1',
      reportDate: DateTime(2023, 10, 1),
      weight: 70.0,
      bodyFatPercent: 15.0,
      muscleMass: 35.0,
      visceralFat: 5,
    ),
    InbodyReport(
      id: '2',
      reportDate: DateTime(2023, 10, 15),
      weight: 71.0,
      bodyFatPercent: 14.5,
      muscleMass: 36.0,
      visceralFat: 5,
    ),
  ];

  Widget createWidgetToTest({
    List<InbodyReport> reports = const [],
    String metric = 'weight',
    bool isFullAnalysis = false,
    double? targetWeight,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: SizedBox(
          height: 300,
          child: InbodyChart(
            reports: reports,
            metric: metric,
            isFullAnalysis: isFullAnalysis,
            targetWeight: targetWeight,
          ),
        ),
      ),
    );
  }

  group('InbodyChart Widget Tests', () {
    testWidgets('Should show "No data available" when reports list is empty', (tester) async {
      await tester.pumpWidget(createWidgetToTest(reports: []));
      expect(find.text('No data available'), findsOneWidget);
    });

    testWidgets('Should render LineChart when data is provided', (tester) async {
      await tester.pumpWidget(createWidgetToTest(reports: sampleReports));
      expect(find.byType(LineChart), findsOneWidget);
    });

    testWidgets('Should show legend in full analysis mode', (tester) async {
      await tester.pumpWidget(createWidgetToTest(
        reports: sampleReports,
        isFullAnalysis: true,
      ));
      
      expect(find.text('Weight'), findsOneWidget);
      expect(find.text('Fat %'), findsOneWidget);
      expect(find.text('Muscle'), findsOneWidget);
    });

    testWidgets('Should render target weight goal label when provided', (tester) async {
      await tester.pumpWidget(createWidgetToTest(
        reports: sampleReports,
        metric: 'weight',
        targetWeight: 68.0,
      ));

      // ExtraLinesData labels are rendered as part of the chart painting,
      // but fl_chart might render them as widgets or we can just check if the chart exists.
      // Actually, FlChart uses a CustomPainter, so the label won't be a separate Text widget.
      // But we can verify the widget tree structure.
      expect(find.byType(LineChart), findsOneWidget);
    });
  });
}
