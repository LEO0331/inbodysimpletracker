import 'package:flutter/material.dart';

import '../../data/models/inbody_report.dart';
import '../../data/services/firestore_service.dart';

class ReportProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  List<InbodyReport> reports = [];

  void listenReports(String uid) {
    _firestoreService.getReports(uid).listen((data) {
      reports = data;
      notifyListeners();
    });
  }

  Future<void> addReport(String uid, InbodyReport report) async {
    await _firestoreService.addReport(uid, report);
  }
}
