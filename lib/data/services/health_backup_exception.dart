class HealthBackupException implements Exception {
  const HealthBackupException(this.message);
  final String message;
  @override
  String toString() => message;
}
