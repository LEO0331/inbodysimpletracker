import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';

// ✅ 核心解決方案：根據編譯環境自動載入對應檔案
import 'mqtt_setup_mobile.dart' if (dart.library.html) 'mqtt_setup_web.dart';

import '../../data/models/inbody_report.dart';

class MqttProvider with ChangeNotifier {
  MqttClient? _client; // 這裡使用基底類別 MqttClient
  List<InbodyReport> mqttReports = [];
  bool _isConnected = false;

  bool get isConnected => _isConnected;

  void initMqtt() async {
    const String broker = 'broker.emqx.io';
    final String uniqueId = 'flutter_client_${DateTime.now().millisecondsSinceEpoch}';

    // ✅ 呼叫工廠方法，它會根據平台自動回傳對應的 Client
    _client = getMqttClient(broker, uniqueId);
    _client!.keepAlivePeriod = 20;
    
    try {
      await _client!.connect();
      _isConnected = true;
      _client!.subscribe("inbody/reports/json", MqttQos.atLeastOnce);
      
      _client!.updates!.listen((List<MqttReceivedMessage<MqttMessage>> c) {
        // ✅ 修正語法錯誤：c 是一個 List，必須存取第一個元素 [0]
        final MqttPublishMessage recMess = c[0].payload as MqttPublishMessage;
        final String pt = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
        
        _handleIncomingJson(pt);
      });
      
      notifyListeners();
    } catch (e) {
      _isConnected = false;
      notifyListeners();
    }
  }

  void _handleIncomingJson(String rawJson) {
    try {
      final Map<String, dynamic> data = jsonDecode(rawJson);
      final newReport = InbodyReport.fromMap(
        "mqtt_${DateTime.now().millisecondsSinceEpoch}", 
        data
      );
      
      mqttReports.insert(0, newReport);
      notifyListeners();
    } catch (e) {
      debugPrint("JSON 解析失敗: $e");
    }
  }
}
