import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/training_checkpoint.dart';

/// Decode acknowledged metadata while retaining older records without dates.
List<TrainingCheckpoint> decodeCheckpointSnapshotRecords(
  Iterable<({String id, Map<String, dynamic> data, bool hasPendingWrites})>
  records,
) {
  final checkpoints = records
      .where((record) => !record.hasPendingWrites)
      .map((record) => TrainingCheckpoint.fromMap(record.id, record.data))
      .toList();
  checkpoints.sort((a, b) {
    final dateOrder = b.checkpointDate.compareTo(a.checkpointDate);
    return dateOrder != 0 ? dateOrder : a.id.compareTo(b.id);
  });
  return checkpoints;
}

class CheckpointService {
  final FirebaseFirestore _db;

  CheckpointService({FirebaseFirestore? db})
    : _db = db ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _collection(String uid) =>
      _db.collection('users').doc(uid).collection('checkpoints');

  String createId(String uid) => _collection(uid).doc().id;

  Stream<List<TrainingCheckpoint>> getCheckpoints(String uid) =>
      _collection(uid)
          .snapshots(includeMetadataChanges: true)
          .map(
            (snapshot) => decodeCheckpointSnapshotRecords(
              snapshot.docs.map(
                (doc) => (
                  id: doc.id,
                  data: doc.data(),
                  hasPendingWrites: doc.metadata.hasPendingWrites,
                ),
              ),
            ),
          );

  Future<void> saveCheckpoint(String uid, TrainingCheckpoint checkpoint) =>
      _collection(uid).doc(checkpoint.id).set(checkpoint.toMap());

  Future<void> deleteCheckpoint(String uid, String id) =>
      _collection(uid).doc(id).delete();
}
