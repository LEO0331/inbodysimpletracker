import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:inbodysimpletracker/core/utils/health_aggregation.dart';
import 'package:inbodysimpletracker/data/models/health_observation.dart';
import 'package:inbodysimpletracker/data/models/health_summary_window.dart';
import 'package:inbodysimpletracker/data/services/health_summary_cache.dart';
import 'package:inbodysimpletracker/logic/providers/health_provider.dart';
import 'package:inbodysimpletracker/presentation/health/health_timeline_page.dart';

import 'provider_test.dart' show FakeHealthRepository;

class CachedHealthRepository extends FakeHealthRepository
    implements HealthSummaryCache {
  HealthSummaryWindow window = const HealthSummaryWindow(summaries: []);
  int cacheCalls = 0;
  int rawCalls = 0;
  String? requestedSource;
  int? requestedOffset;
  Completer<void>? cacheBarrier;
  @override
  Future<HealthSummaryWindow> queryDailySummaries({
    required DateTime from,
    required DateTime to,
    required HealthMetric metric,
    String? source,
    int? offsetMinutes,
  }) async {
    cacheCalls++;
    requestedSource = source;
    requestedOffset = offsetMinutes;
    if (cacheBarrier != null) await cacheBarrier!.future;
    return window;
  }

  @override
  Future<List<HealthObservation>> queryObservations({
    required DateTime from,
    required DateTime to,
    HealthMetric? metric,
    String? source,
    int limit = 1000,
    int offset = 0,
  }) async {
    rawCalls++;
    return super.queryObservations(
      from: from,
      to: to,
      metric: metric,
      source: source,
      limit: limit,
      offset: offset,
    );
  }
}

HealthDailySummary summary(DateTime date) => HealthDailySummary(
  date: date,
  metric: HealthMetric.steps,
  source: 'Synthetic source',
  value: 1000,
  unit: 'count',
  sampleCount: 100,
  hasConflict: false,
);

void main() {
  testWidgets(
    'timeline keeps valid cached dates visible beside withheld dates',
    (tester) async {
      final day = DateTime.utc(2026, 1, 1);
      final repo = CachedHealthRepository()
        ..window = HealthSummaryWindow(
          summaries: [summary(day.add(const Duration(days: 1)))],
          limitedDays: [day],
        );
      final provider = HealthProvider(repository: repo)
        ..week = day
        ..metric = HealthMetric.steps;
      await provider.open();
      await tester.binding.setSurfaceSize(const Size(1000, 1800));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider.value(
            value: provider,
            child: const HealthTimelinePage(),
          ),
        ),
      );
      expect(
        find.text('Summary withheld · incomplete or excessive observations'),
        findsOneWidget,
      );
      expect(find.text('1000.00 count'), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
      provider.dispose();
    },
  );
  test(
    'provider uses cache capability without loading raw observations',
    () async {
      final day = DateTime.utc(2026, 1, 1);
      final repo = CachedHealthRepository()
        ..window = HealthSummaryWindow(
          summaries: [summary(day)],
          cacheHitDays: 7,
        );
      final provider = HealthProvider(repository: repo)..week = day;
      await provider.open();
      expect(provider.summaries.single.value, 1000);
      expect(provider.cacheHitDays, 7);
      expect(repo.rawCalls, 0);
      await provider.setFilter(selectedOffset: 480);
      expect(repo.requestedOffset, 480);
      expect(repo.rawCalls, 0);
      provider.dispose();
    },
  );

  test('one withheld date does not hide valid dates from the week', () async {
    final day = DateTime.utc(2026, 1, 1);
    final repo = CachedHealthRepository()
      ..window = HealthSummaryWindow(
        summaries: [summary(day.add(const Duration(days: 1)))],
        limitedDays: [day],
      );
    final provider = HealthProvider(repository: repo)..week = day;
    await provider.open();
    expect(provider.truncated, isTrue);
    expect(provider.withheldDays, [day]);
    expect(provider.summaries, hasLength(1));
    expect(provider.summaries.single.date, day.add(const Duration(days: 1)));
    provider.dispose();
  });

  test(
    'locking while cache read is pending cannot republish private summaries',
    () async {
      final day = DateTime.utc(2026, 1, 1);
      final repo = CachedHealthRepository()
        ..window = HealthSummaryWindow(
          summaries: [summary(day)],
          cacheHitDays: 7,
        )
        ..cacheBarrier = Completer<void>();
      final provider = HealthProvider(repository: repo)..week = day;
      final opening = provider.open();
      await Future<void>.delayed(Duration.zero);
      await provider.lock();
      repo.cacheBarrier!.complete();
      await opening;
      expect(provider.unlocked, isFalse);
      expect(provider.summaries, isEmpty);
      expect(provider.cacheHitDays, 0);
      expect(repo.closeCount, greaterThan(0));
      provider.dispose();
    },
  );
}
