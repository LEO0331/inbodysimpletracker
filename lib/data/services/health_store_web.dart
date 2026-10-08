import 'health_repository.dart';

HealthRepository createHealthRepository() => UnsupportedHealthRepository();

/// Never substitutes browser storage or a plaintext database for the private vault.
class UnsupportedHealthRepository implements HealthRepository {
  Never _unsupported() =>
      throw UnsupportedError('Private Health requires iOS or Android.');
  @override
  dynamic noSuchMethod(Invocation invocation) => _unsupported();
  @override
  Future<void> open() async => _unsupported();
  @override
  Future<void> close() async {}
}
