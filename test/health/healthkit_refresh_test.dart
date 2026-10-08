import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inbodysimpletracker/data/models/health_observation.dart';
import 'package:inbodysimpletracker/data/services/healthkit_client.dart';
import 'package:inbodysimpletracker/data/services/healthkit_refresh_service.dart';
import 'package:inbodysimpletracker/data/services/healthkit_repository.dart';

String anchor(int index) => base64Encode([index]);
const sampleId = 'hk:steps:00000000-0000-0000-0000-000000000001';
HealthObservation sample({String id = sampleId, double value = 4}) =>
    HealthObservation(
      id: id,
      logicalId: id,
      metric: HealthMetric.steps,
      source: 'HealthKit · Synthetic Watch',
      rawValue: '$value',
      originalUnit: 'count',
      canonicalUnit: 'count',
      value: value,
      start: DateTime.utc(2026),
      end: DateTime.utc(2026),
      offsetMinutes: 0,
    );
HealthKitPage page(
  int index, {
  bool more = false,
  List<HealthObservation> samples = const [],
  List<String> deleted = const [],
}) => HealthKitPage(
  samples: samples,
  deletedIds: deleted,
  anchor: anchor(index),
  more: more,
);

class FakeClient implements HealthKitClient {
  final pages = <HealthKitPage>[];
  final requestedAnchors = <String?>[];
  bool available = true, authorizationCompleted = true, cancelled = false;
  int authorizations = 0;
  Completer<HealthKitPage>? pending;
  @override
  Future<bool> isAvailable() async => available;
  @override
  Future<bool> requestAuthorization(List<HealthMetric> metrics) async {
    authorizations++;
    return authorizationCompleted;
  }

  @override
  Future<HealthKitPage> readPage(HealthMetric metric, String? anchor) async {
    requestedAnchors.add(anchor);
    if (pending != null) return pending!.future;
    return pages.removeAt(0);
  }

  @override
  Future<void> cancel() async {
    cancelled = true;
  }
}

class FakeRepository implements HealthKitRepository {
  String? anchor;
  int commits = 0;
  bool failCommit = false;
  bool hasMore = false;
  final stored = <String, HealthObservation>{};
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
    if (failCommit || expectedAnchor != anchor) {
      throw StateError('private database path');
    }
    for (final id in deletedIds) {
      stored.remove(id);
    }
    for (final sample in samples) {
      stored[sample.id] = sample;
    }
    anchor = nextAnchor;
    this.hasMore = hasMore;
    commits++;
  }

  @override
  Future<void> deleteHealthKitData() async {
    anchor = null;
    stored.clear();
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const channel = MethodChannel('inbodysimpletracker/private_health');
  tearDown(() {
    debugDefaultTargetPlatformOverride = null;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('unsupported platforms do not invoke the native channel', () async {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    var calls = 0;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (_) async {
          calls++;
          return true;
        });
    const client = MethodChannelHealthKitClient();
    expect(await client.isAvailable(), false);
    await client.cancel();
    await expectLater(
      client.readPage(HealthMetric.steps, null),
      throwsA(isA<HealthKitException>()),
    );
    expect(calls, 0);
  });

  test('native maps are validated before exposing typed samples', () async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
          expect(call.method, 'healthKitReadPage');
          expect(call.arguments, {
            'metric': 'steps',
            'anchor': null,
            'limit': 500,
          });
          return {
            'samples': [sample().toMap()],
            'deletedIds': <String>[],
            'anchor': anchor(1),
            'more': false,
          };
        });
    const client = MethodChannelHealthKitClient();
    expect(
      (await client.readPage(HealthMetric.steps, null)).samples.single.id,
      sampleId,
    );
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          channel,
          (_) async => {
            'samples': [
              {'private malformed row': 'personal sample'},
            ],
            'deletedIds': <String>[],
            'anchor': anchor(2),
            'more': false,
          },
        );
    await expectLater(
      client.readPage(HealthMetric.steps, null),
      throwsA(
        isA<HealthKitException>().having(
          (error) => error.message,
          'safe message',
          isNot(contains('personal sample')),
        ),
      ),
    );
  });

  test(
    'incremental pages advance cursor only with committed changes',
    () async {
      final repository = FakeRepository()..anchor = anchor(1);
      final client = FakeClient()
        ..pages.addAll([
          page(2, more: true, samples: [sample()]),
          page(3, deleted: [sampleId]),
        ]);
      final progress = <HealthKitRefreshProgress>[];
      final result = await HealthKitRefreshService(repository, client: client)
          .refresh(
            [HealthMetric.steps],
            requestAuthorization: true,
            onProgress: progress.add,
          );
      expect(client.requestedAnchors, [anchor(1), anchor(2)]);
      expect(repository.anchor, anchor(3));
      expect(repository.commits, 2);
      expect(repository.stored, isEmpty);
      expect(client.authorizations, 1);
      expect(result.samples, 1);
      expect(result.deletions, 1);
      expect(progress.last.pages, 2);
    },
  );

  test('empty reads do not imply permission denied', () async {
    final repository = FakeRepository();
    final client = FakeClient()..pages.add(page(1));
    final result = await HealthKitRefreshService(
      repository,
      client: client,
    ).refresh([HealthMetric.steps], requestAuthorization: true);
    expect(result.samples, 0);
    expect(repository.anchor, anchor(1));
  });

  test(
    'unchanged empty final page completes a resumed partial metric',
    () async {
      final repository = FakeRepository()
        ..anchor = anchor(1)
        ..hasMore = true;
      final client = FakeClient()..pages.add(page(1));
      await HealthKitRefreshService(
        repository,
        client: client,
      ).refresh([HealthMetric.steps]);
      expect(repository.commits, 1);
      expect(repository.hasMore, false);
      expect(repository.anchor, anchor(1));
    },
  );

  test('failed transaction leaves cursor and prior data intact', () async {
    final repository = FakeRepository()
      ..anchor = anchor(1)
      ..failCommit = true;
    final client = FakeClient()..pages.add(page(2, samples: [sample()]));
    await expectLater(
      HealthKitRefreshService(
        repository,
        client: client,
      ).refresh([HealthMetric.steps]),
      throwsA(
        isA<HealthKitException>().having(
          (error) => error.message,
          'safe message',
          isNot(contains('private database path')),
        ),
      ),
    );
    expect(repository.anchor, anchor(1));
    expect(repository.commits, 0);
  });

  test('cancelled in-flight query cannot advance cursor', () async {
    final repository = FakeRepository();
    final client = FakeClient()..pending = Completer<HealthKitPage>();
    final service = HealthKitRefreshService(repository, client: client);
    final refresh = service.refresh([HealthMetric.steps]);
    final failure = expectLater(refresh, throwsA(isA<HealthKitException>()));
    await Future<void>.delayed(Duration.zero);
    await service.cancel();
    client.pending!.complete(page(1, samples: [sample()]));
    await failure;
    expect(client.cancelled, true);
    expect(repository.commits, 0);
  });

  test(
    'rejects concurrent refresh and resets running state after cancellation',
    () async {
      final repository = FakeRepository();
      final client = FakeClient()..pending = Completer<HealthKitPage>();
      final service = HealthKitRefreshService(repository, client: client);
      final first = service.refresh([HealthMetric.steps]);
      final failure = expectLater(first, throwsA(isA<HealthKitException>()));
      await Future<void>.delayed(Duration.zero);
      await expectLater(
        service.refresh([HealthMetric.steps]),
        throwsA(isA<HealthKitException>()),
      );
      await service.cancel();
      client.pending!.complete(page(1));
      await failure;
      client.pending = null;
      client.pages.add(page(2));
      await service.refresh([HealthMetric.steps]);
      expect(repository.anchor, anchor(2));
    },
  );

  test('invalid native data cannot commit or move cursor', () async {
    for (final invalid in [
      page(1, samples: [sample(id: 'export-record')]),
      page(1, samples: [sample(value: double.nan)]),
      page(1, samples: [sample(), sample()]),
      page(1, deleted: ['hk:weight:00000000-0000-0000-0000-000000000001']),
      HealthKitPage(
        samples: [],
        deletedIds: [],
        anchor: 'invalid!',
        more: false,
      ),
      page(1, samples: List.generate(501, (_) => sample())),
    ]) {
      final repository = FakeRepository();
      final client = FakeClient()..pages.add(invalid);
      await expectLater(
        HealthKitRefreshService(
          repository,
          client: client,
        ).refresh([HealthMetric.steps]),
        throwsA(isA<HealthKitException>()),
      );
      expect(repository.commits, 0);
    }
  });

  test('unchanged cursor with more pages fails instead of looping', () async {
    final repository = FakeRepository()..anchor = anchor(1);
    final client = FakeClient()..pages.add(page(1, more: true));
    await expectLater(
      HealthKitRefreshService(
        repository,
        client: client,
      ).refresh([HealthMetric.steps]),
      throwsA(isA<HealthKitException>()),
    );
    expect(repository.commits, 0);
  });

  test(
    'unavailable or incomplete authorization does not query or commit',
    () async {
      for (final available in [false, true]) {
        final repository = FakeRepository();
        final client = FakeClient()
          ..available = available
          ..authorizationCompleted = false;
        await expectLater(
          HealthKitRefreshService(
            repository,
            client: client,
          ).refresh([HealthMetric.steps], requestAuthorization: true),
          throwsA(isA<HealthKitException>()),
        );
        expect(client.requestedAnchors, isEmpty);
        expect(repository.commits, 0);
      }
    },
  );
}
