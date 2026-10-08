import 'health_backup_exception.dart';
import 'health_repository.dart';

class HealthBackupService {
  HealthBackupService(HealthRepository repository);
  Future<void> exportToFile(String path, String passphrase) async =>
      throw const HealthBackupException(
        'Private Health backups require the mobile app.',
      );
  Future<void> restoreFromFile(String path, String passphrase) async =>
      throw const HealthBackupException(
        'Private Health backups require the mobile app.',
      );
}
