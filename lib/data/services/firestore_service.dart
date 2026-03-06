import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inbodysimpletracker/data/models/inbody_report.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addReport(String uid, InbodyReport report) async {
    await _db.collection("users").doc(uid).collection("reports").add(report.toMap());
  }

  Stream<List<InbodyReport>> getReports(String uid) {
    return _db.collection("users").doc(uid).collection("reports")
      .orderBy("reportDate", descending: true)
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) => InbodyReport.fromMap(doc.id, doc.data())).toList());
  }
}
