import 'dart:async';
import 'package:flutter/material.dart';

import '../../data/models/inbody_report.dart';
import '../../data/services/firestore_service.dart';

class ReportProvider with ChangeNotifier {
  final FirestoreService _firestoreService;
  StreamSubscription<List<InbodyReport>>? _reportsSubscription;
  List<InbodyReport> reports = [];
  ReportProvider({FirestoreService? firestoreService})
    : _firestoreService = firestoreService ?? FirestoreService();

  void listenReports(String uid) {
    _reportsSubscription?.cancel();
    _reportsSubscription = _firestoreService.getReports(uid).listen((data) {
      reports = data;
      notifyListeners();
    });
  }

  Future<void> addReport(String uid, InbodyReport report) async {
    await _firestoreService.addReport(uid, report);
  }

  @override
  void dispose() {
    _reportsSubscription?.cancel();
    super.dispose();
  }
}
