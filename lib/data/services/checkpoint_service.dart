import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/training_checkpoint.dart';

class CheckpointService {
  final FirebaseFirestore _db;

  CheckpointService({FirebaseFirestore? db})
    : _db = db ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _collection(String uid) =>
      _db.collection('users').doc(uid).collection('checkpoints');

  String createId(String uid) => _collection(uid).doc().id;

  Stream<List<TrainingCheckpoint>> getCheckpoints(String uid) =>
      _collection(uid)
          .orderBy('checkpointDate', descending: true)
          .snapshots()
          .map(
            (snapshot) => snapshot.docs
                .map((doc) => TrainingCheckpoint.fromMap(doc.id, doc.data()))
                .toList(),
          );

  Future<void> saveCheckpoint(String uid, TrainingCheckpoint checkpoint) =>
      _collection(uid).doc(checkpoint.id).set(checkpoint.toMap());

  Future<void> deleteCheckpoint(String uid, String id) =>
      _collection(uid).doc(id).delete();
}
