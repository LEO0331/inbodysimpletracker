import 'package:cloud_firestore/cloud_firestore.dart';

enum CheckpointSide { left, right, bilateral, notApplicable }

enum CameraAngle { front, side, rear, oblique, other }

class TrainingCheckpoint {
  final String id;
  final DateTime checkpointDate;
  final String exerciseName;
  final CheckpointSide side;
  final CameraAngle cameraAngle;
  final double? load;
  final String loadUnit;
  final int? sets;
  final int? reps;
  final double? rpe;
  final String? notes;
  final String localVideoPath;
  final String originalFileName;
  final int? fileSizeBytes;
  final int? durationMs;
  final DateTime createdAt;
  final DateTime updatedAt;

  const TrainingCheckpoint({
    required this.id,
    required this.checkpointDate,
    required this.exerciseName,
    required this.side,
    required this.cameraAngle,
    this.load,
    this.loadUnit = 'kg',
    this.sets,
    this.reps,
    this.rpe,
    this.notes,
    required this.localVideoPath,
    required this.originalFileName,
    this.fileSizeBytes,
    this.durationMs,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() => {
    'checkpointDate': Timestamp.fromDate(checkpointDate),
    'exerciseName': exerciseName,
    'side': side.name,
    'cameraAngle': cameraAngle.name,
    'load': load,
    'loadUnit': loadUnit,
    'sets': sets,
    'reps': reps,
    'rpe': rpe,
    'notes': notes,
    'localVideoPath': localVideoPath,
    'originalFileName': originalFileName,
    'fileSizeBytes': fileSizeBytes,
    'durationMs': durationMs,
    'createdAt': Timestamp.fromDate(createdAt),
    'updatedAt': Timestamp.fromDate(updatedAt),
  };

  factory TrainingCheckpoint.fromMap(String id, Map<String, dynamic>? map) {
    final data = map ?? <String, dynamic>{};
    final fallback = DateTime.fromMillisecondsSinceEpoch(0);
    DateTime date(dynamic value) {
      try {
        if (value is Timestamp) return value.toDate();
        if (value is DateTime) return value;
        if (value is String) return DateTime.tryParse(value) ?? fallback;
      } catch (_) {
        // Malformed imported dates must not prevent the remaining history loading.
      }
      return fallback;
    }

    String string(dynamic value, [String fallback = '']) =>
        value is String ? value : fallback;
    double? number(dynamic value) {
      final parsed = value is num
          ? value.toDouble()
          : value is String
          ? double.tryParse(value)
          : null;
      return parsed != null && parsed.isFinite ? parsed : null;
    }

    int? integer(dynamic value) {
      if (value is String) {
        // Parse decimal strings exactly before converting: large fractional
        // strings can round to whole doubles and must not become valid counts.
        final match = RegExp(
          r'^\+?(\d+)(?:\.(\d*))?(?:[eE]([+-]?\d+))?$',
        ).firstMatch(value.trim());
        if (match == null) return null;
        final fraction = match.group(2) ?? '';
        final exponent = int.tryParse(match.group(3) ?? '0');
        if (exponent == null ||
            exponent > value.length + 16 ||
            exponent < -value.length) {
          return null;
        }
        var digits = '${match.group(1)}$fraction'.replaceFirst(
          RegExp(r'^0+'),
          '',
        );
        if (digits.isEmpty) return 0;
        final scale = exponent - fraction.length;
        if (scale >= 0) {
          if (digits.length + scale > 16) return null;
          digits = '$digits${'0' * scale}';
        } else {
          final remove = -scale;
          if (remove >= digits.length || !digits.endsWith('0' * remove)) {
            return null;
          }
          digits = digits.substring(0, digits.length - remove);
        }
        final exact = int.tryParse(digits);
        return exact != null && exact <= 9007199254740991 ? exact : null;
      }
      final parsed = number(value);
      return parsed != null &&
              parsed >= 0 &&
              parsed <= 9007199254740991 &&
              parsed == parsed.truncateToDouble()
          ? parsed.toInt()
          : null;
    }

    T enumValue<T extends Enum>(List<T> values, dynamic raw, T fallback) =>
        values.where((value) => value.name == raw).firstOrNull ?? fallback;
    final parsedLoad = number(data['load']);
    final parsedRpe = number(data['rpe']);
    return TrainingCheckpoint(
      id: id,
      checkpointDate: date(data['checkpointDate']),
      exerciseName: string(data['exerciseName']),
      side: enumValue(
        CheckpointSide.values,
        data['side'],
        CheckpointSide.notApplicable,
      ),
      cameraAngle: enumValue(
        CameraAngle.values,
        data['cameraAngle'],
        CameraAngle.other,
      ),
      load: parsedLoad != null && parsedLoad >= 0 ? parsedLoad : null,
      loadUnit: string(data['loadUnit'], 'kg'),
      sets: integer(data['sets']),
      reps: integer(data['reps']),
      rpe: parsedRpe != null && parsedRpe >= 1 && parsedRpe <= 10
          ? parsedRpe
          : null,
      notes: data['notes'] is String ? data['notes'] as String : null,
      localVideoPath: string(data['localVideoPath']),
      originalFileName: string(data['originalFileName']),
      fileSizeBytes: integer(data['fileSizeBytes']),
      durationMs: integer(data['durationMs']),
      createdAt: date(data['createdAt']),
      updatedAt: date(data['updatedAt']),
    );
  }
}
