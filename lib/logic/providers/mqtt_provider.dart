import 'dart:convert';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';

// ✅ 根據平台引入不同的 Client 設置
import 'mqtt_setup_mobile.dart' if (dart.library.html) 'mqtt_setup_web.dart';

import '../../data/models/inbody_report.dart';
import '../../data/services/firestore_service.dart'; // ✅ 引入 Firestore 服務

class MqttProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  MqttClient? _client;
  
  List<InbodyReport> mqttReports = [];
  bool _isConnected = false;
  bool _isLoading = false;

  bool get isConnected => _isConnected;
  bool get isLoading => _isLoading;

  /// 初始化 MQTT 並訂閱使用者專屬 Topic
  Future<void> initMqtt(String uid) async {
    if (_isConnected || _isLoading) return;

    _isLoading = true;
    notifyListeners();

    const String broker = 'broker.emqx.io';
    final String uniqueId = 'flutter_${uid}_${DateTime.now().millisecondsSinceEpoch}';

    // 透過條件式引入的方法獲取 Client (Web 或 Mobile)
    _client = getMqttClient(broker, uniqueId);
    _client!.keepAlivePeriod = 20;
    
    // 設定連線回調
    _client!.onDisconnected = () {
      _isConnected = false;
      notifyListeners();
      developer.log("MQTT Disconnected", name: "mqtt.provider");
    };

    try {
      await _client!.connect();
      _isConnected = true;

      // ✅ 訂閱路徑：inbody/users/{uid}/data
      final String userTopic = "inbody/users/$uid/data";
      _client!.subscribe(userTopic, MqttQos.atLeastOnce);
      
      developer.log("📡 Subscribed to: $userTopic", name: "mqtt.provider");

      _client!.updates!.listen((List<MqttReceivedMessage<MqttMessage>> c) {
        final MqttPublishMessage recMess = c[0].payload as MqttPublishMessage;
        final String pt = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
        
        // 收到數據，傳入 uid 進行處理與儲存
        _handleIncomingJson(pt, uid);
      });

    } catch (e) {
      developer.log("MQTT Connect Error", name: "mqtt.provider", error: e);
      _isConnected = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 處理收到的 JSON 數據並自動儲存
  void _handleIncomingJson(String rawJson, String uid) async {
    try {
      final Map<String, dynamic> data = jsonDecode(rawJson);
      
      // 1. 解析為模型
      final newReport = InbodyReport.fromMap(
        "mqtt_${DateTime.now().millisecondsSinceEpoch}", 
        data
      );

      // 2. 更新本地 UI (藍色即時區塊)
      mqttReports.insert(0, newReport);
      notifyListeners();

      // 3. ✅ 自動儲存到 Firestore
      await _firestoreService.addReport(uid, newReport);
      developer.log("✅ Auto-saved MQTT report to Firestore", name: "mqtt.provider");

    } catch (e) {
      developer.log("JSON Parsing/Saving Error", name: "mqtt.provider", error: e);
    }
  }

  void disconnect() {
    _client?.disconnect();
  }
}
