import 'dart:convert';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';

// ✅ 根據平台引入不同的 Client 設置
import 'mqtt_setup_mobile.dart' if (dart.library.html) 'mqtt_setup_web.dart';

import '../../data/models/inbody_report.dart';
import '../../data/services/firestore_service.dart';

class MqttProvider with ChangeNotifier {
  final FirestoreService _firestoreService;
  MqttClient? _client;

  MqttProvider({FirestoreService? firestoreService, MqttClient? client})
      : _firestoreService = firestoreService ?? FirestoreService(),
        _client = client;
  
  List<InbodyReport> mqttReports = [];
  bool _isConnected = false;
  bool _isLoading = false;

  bool get isConnected => _isConnected;
  bool get isLoading => _isLoading;

  /// 初始化 MQTT 並訂閱使用者專屬 Topic
  Future<void> initMqtt(String uid) async {
    developer.log("🚀 開始連線 MQTT，UID: $uid", name: "mqtt.provider");
    if (_isConnected || _isLoading) return;

    _isLoading = true;
    mqttReports.clear(); // 清除舊數據
    notifyListeners();

    const String broker = 'broker.emqx.io';
    final String uniqueId = 'flutter_${uid}_${DateTime.now().millisecondsSinceEpoch}';

    // ✅ 自定義 Topic 路徑 (發送端 MQTTX 需對應此路徑)
    final String userTopic = "inbody/users/$uid/data";
    final String statusTopic = "inbody/users/$uid/status";
    
    // ✅ Use injected client if available, otherwise create new
    _client ??= getMqttClient(broker, uniqueId);
    
    _client!.keepAlivePeriod = 20;
    
    // ✅ 設定連線訊息與遺囑 (Last Will)
    final connMessage = MqttConnectMessage()
        .withClientIdentifier(uniqueId)
        .startClean()
        .withWillTopic(statusTopic) // 如果斷線，自動發布到 status 主題
        .withWillMessage('offline')
        .withWillQos(MqttQos.atLeastOnce)
        .withWillRetain();
    
    _client!.connectionMessage = connMessage;

    _client!.onDisconnected = () {
      _isConnected = false;
      notifyListeners();
      developer.log("MQTT Disconnected for user: $uid", name: "mqtt.provider");
    };

    try {
      await _client!.connect();
      _isConnected = true;

      // ✅ 訂閱自定義 Topic
      _client!.subscribe(userTopic, MqttQos.atLeastOnce);
      developer.log("📡 Subscribed to: $userTopic", name: "mqtt.provider");

      // 連線後發布一個在線狀態 (選配)
      final builder = MqttClientPayloadBuilder();
      builder.addString('online');
      _client!.publishMessage(statusTopic, MqttQos.atLeastOnce, builder.payload!, retain: true);

      _client!.updates!.listen((List<MqttReceivedMessage<MqttMessage>> c) {
        final MqttPublishMessage recMess = c[0].payload as MqttPublishMessage;
        final String pt = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
        
        // 收到數據，傳入 uid 進行儲存
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

  void _handleIncomingJson(String rawJson, String uid) async {
    try {
      final Map<String, dynamic> data = jsonDecode(rawJson);
      
      final newReport = InbodyReport.fromMap(
        "mqtt_${DateTime.now().millisecondsSinceEpoch}", 
        data
      );

      mqttReports.insert(0, newReport);
      notifyListeners();

      // ✅ 自動儲存到 Firestore
      await _firestoreService.addReport(uid, newReport);
      developer.log("✅ Auto-saved report to Firestore", name: "mqtt.provider");

    } catch (e) {
      developer.log("JSON Parsing Error", name: "mqtt.provider", error: e);
    }
  }

  void disconnect() {
    _client?.disconnect();
    _isConnected = false;
    notifyListeners();
  }
}
