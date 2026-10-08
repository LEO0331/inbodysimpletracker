import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:inbodysimpletracker/data/models/health_observation.dart';
import 'package:inbodysimpletracker/data/services/healthkit_client.dart';
import 'package:inbodysimpletracker/data/services/healthkit_repository.dart';
import 'package:inbodysimpletracker/logic/providers/health_provider.dart';
import 'package:inbodysimpletracker/presentation/health/healthkit_page.dart';
import 'provider_test.dart' show FakeHealthRepository;

class LiveRepository extends FakeHealthRepository
    implements HealthKitRepository {
  int applyCount = 0;
  int clearCount = 0;
  String? anchor;
  bool complete = false;
  @override
  Future<String?> readHealthKitAnchor(HealthMetric metric) async => anchor;
  @override
  Future<void> applyHealthKitPage({
    required HealthMetric metric,
    required String? expectedAnchor,
    required String nextAnchor,
    required List<HealthObservation> samples,
    required List<String> deletedIds,
    bool hasMore = false,
  }) async {
    applyCount++;
    anchor = nextAnchor;
    rows.addAll(samples);
    complete = !hasMore;
  }

  @override
  Future<List<HealthObservation>> queryObservations({
    required DateTime from,
    required DateTime to,
    HealthMetric? metric,
    String? source,
    int limit = 1000,
    int offset = 0,
  }) async => complete
      ? super.queryObservations(
          from: from,
          to: to,
          metric: metric,
          source: source,
          limit: limit,
          offset: offset,
        )
      : [];

  @override
  Future<List<String>> listSources(HealthMetric metric) async =>
      complete ? super.listSources(metric) : [];

  @override
  Future<List<HealthImportBatch>> listImports() async => !complete
      ? []
      : [
          HealthImportBatch(
            id: 'healthkit_live:weight',
            createdAt: DateTime.utc(2026),
            status: 'ready',
            recordCount: rows.length,
            skippedCount: 0,
          ),
        ];

  @override
  Future<void> deleteHealthKitData() async {
    clearCount++;
    anchor = null;
    complete = false;
    rows.clear();
  }
}

class FakeClient implements HealthKitClient {
  int authorizeCount = 0;
  int availableCount = 0;
  int readCount = 0;
  int cancelCount = 0;
  Completer<HealthKitPage>? barrier;
  static const emptyPage = HealthKitPage(
    samples: [],
    deletedIds: [],
    anchor: 'AQ==',
    more: false,
  );
  @override
  Future<bool> isAvailable() async {
    availableCount++;
    return true;
  }

  @override
  Future<bool> requestAuthorization(List<HealthMetric> metrics) async {
    authorizeCount++;
    return true;
  }

  @override
  Future<HealthKitPage> readPage(HealthMetric metric, String? anchor) async {
    readCount++;
    return barrier == null ? emptyPage : barrier!.future;
  }

  @override
  Future<void> cancel() async {
    cancelCount++;
  }
}

class PartialClient extends FakeClient {
  PartialClient({this.waitForSecond = false});
  final bool waitForSecond;
  final secondPage = Completer<HealthKitPage>();
  @override
  Future<HealthKitPage> readPage(HealthMetric metric, String? anchor) async {
    readCount++;
    if (readCount == 1) {
      return HealthKitPage(
        samples: [
          HealthObservation(
            id: 'hk:weight:00000000-0000-0000-0000-000000000001',
            logicalId: 'hk:weight:00000000-0000-0000-0000-000000000001',
            metric: HealthMetric.weight,
            source: 'HealthKit · Synthetic source',
            rawValue: '70',
            originalUnit: 'kg',
            canonicalUnit: 'kg',
            value: 70,
            start: DateTime.utc(2026, 1, 1),
            end: DateTime.utc(2026, 1, 1),
            offsetMinutes: 0,
          ),
        ],
        deletedIds: [],
        anchor: 'AQ==',
        more: true,
      );
    }
    if (waitForSecond) return secondPage.future;
    throw const HealthKitException(
      'Private Health refresh could not finish. Refresh again to resume.',
    );
  }
}

void main() {
  test(
    'later page error hides incomplete HealthKit projections until resume',
    () async {
      final repo = LiveRepository()..complete = true;
      repo.rows.addAll(
        (await PartialClient().readPage(HealthMetric.weight, null)).samples,
      );
      final client = PartialClient();
      final vault = HealthProvider(
        repository: repo,
        healthKitClient: client,
        personalImportEnabled: true,
      )..week = DateTime.utc(2026, 1, 1);
      await vault.open();
      expect(vault.summaries.single.value, 70);
      expect(vault.imports, hasLength(1));
      await vault.refreshHealthKit([HealthMetric.weight]);
      expect(repo.applyCount, 1);
      expect(repo.rows.last.value, 70);
      expect(vault.summaries, isEmpty);
      expect(vault.imports, isEmpty);
      expect(vault.error, contains('Refresh again to resume'));
      expect(vault.resultMessage, isNull);
      vault.dispose();
    },
  );

  test(
    'cancel keeps encrypted progress but hides incomplete projections',
    () async {
      final repo = LiveRepository();
      final client = PartialClient(waitForSecond: true);
      final vault = HealthProvider(
        repository: repo,
        healthKitClient: client,
        personalImportEnabled: true,
      )..week = DateTime.utc(2026, 1, 1);
      await vault.open();
      final refreshing = vault.refreshHealthKit([HealthMetric.weight]);
      while (client.readCount < 2) {
        await Future<void>.delayed(Duration.zero);
      }
      vault.cancelHealthKitRefresh();
      client.secondPage.complete(FakeClient.emptyPage);
      await refreshing;
      expect(repo.applyCount, 1);
      expect(vault.unlocked, isTrue);
      expect(repo.rows.single.value, 70);
      expect(vault.summaries, isEmpty);
      expect(vault.imports, isEmpty);
      expect(vault.error, contains('cancelled'));
      expect(vault.resultMessage, isNull);
      final resumedClient = FakeClient()
        ..barrier = (Completer<HealthKitPage>()
          ..complete(
            const HealthKitPage(
              samples: [],
              deletedIds: [],
              anchor: 'Ag==',
              more: false,
            ),
          ));
      final resumed = HealthProvider(
        repository: repo,
        healthKitClient: resumedClient,
        personalImportEnabled: true,
      )..week = DateTime.utc(2026, 1, 1);
      await resumed.open();
      await resumed.refreshHealthKit([HealthMetric.weight]);
      expect(resumed.summaries.single.value, 70);
      expect(resumed.imports.single.recordCount, 1);
      resumed.dispose();
      vault.dispose();
    },
  );
  test('verification gate blocks permission requests and reads', () async {
    final repo = LiveRepository();
    final client = FakeClient();
    final vault = HealthProvider(repository: repo, healthKitClient: client);
    await vault.open();
    await vault.refreshHealthKit([
      HealthMetric.weight,
    ], requestAuthorization: true);
    await vault.clearHealthKitData();
    expect(client.availableCount, 0);
    expect(client.authorizeCount, 0);
    expect(client.readCount, 0);
    expect(repo.applyCount, 0);
    expect(repo.clearCount, 0);
    expect(vault.error, contains('awaiting native device validation'));
    vault.dispose();
  });

  test(
    'explicit permission request and empty refresh never assert permission',
    () async {
      final repo = LiveRepository();
      final client = FakeClient();
      final vault = HealthProvider(
        repository: repo,
        healthKitClient: client,
        personalImportEnabled: true,
      );
      await vault.open();
      await vault.refreshHealthKit([
        HealthMetric.weight,
      ], requestAuthorization: true);
      expect(client.authorizeCount, 1);
      expect(repo.applyCount, 1);
      expect(vault.resultMessage, contains('do not confirm read permission'));
      await vault.refreshHealthKit([HealthMetric.weight]);
      expect(client.authorizeCount, 1);
      await vault.clearHealthKitData();
      expect(repo.clearCount, 1);
      vault.dispose();
    },
  );

  test('lock cancels refresh before returned page can be applied', () async {
    final repo = LiveRepository();
    final client = FakeClient()..barrier = Completer<HealthKitPage>();
    final vault = HealthProvider(
      repository: repo,
      healthKitClient: client,
      personalImportEnabled: true,
    );
    await vault.open();
    final refreshing = vault.refreshHealthKit([HealthMetric.weight]);
    while (client.readCount == 0) {
      await Future<void>.delayed(Duration.zero);
    }
    await vault.refreshHealthKit([HealthMetric.steps]);
    expect(client.readCount, 1);
    await vault.lock();
    client.barrier!.complete(FakeClient.emptyPage);
    await refreshing;
    expect(client.cancelCount, 1);
    expect(repo.applyCount, 0);
    expect(vault.unlocked, isFalse);
    expect(vault.healthKitProgress, isNull);
    expect(vault.resultMessage, isNull);
    expect(vault.error, isNull);
    expect(repo.opened, isFalse);
    vault.dispose();
  });

  testWidgets('HealthKit controls are gated while guidance remains visible', (
    tester,
  ) async {
    final vault = HealthProvider(
      repository: LiveRepository(),
      healthKitClient: FakeClient(),
    );
    await vault.open();
    await tester.binding.setSurfaceSize(const Size(1000, 1800));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider.value(
          value: vault,
          child: const AppleHealthRefreshPage(),
        ),
      ),
    );
    final connect = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Choose access and refresh'),
    );
    expect(connect.onPressed, isNull);
    expect(
      find.textContaining('does not prove that read access was granted'),
      findsOneWidget,
    );
    expect(
      find.textContaining('overlapping history is never added together'),
      findsOneWidget,
    );
    await tester.pumpWidget(const SizedBox());
    vault.dispose();
  });
}
