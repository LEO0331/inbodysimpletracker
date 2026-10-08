import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';

import '../../data/models/inbody_report.dart';
import '../../data/services/firestore_service.dart';

class MqttProvider with ChangeNotifier {
  final FirestoreService _firestoreService;
  final MqttClient? _client;
  StreamSubscription<List<MqttReceivedMessage<MqttMessage>>>?
  _updatesSubscription;
  bool _isDisposed = false;
  final bool enabled;

  MqttProvider({
    FirestoreService? firestoreService,
    this._client,
    this.enabled = false,
  }) : _firestoreService = firestoreService ?? FirestoreService();

  List<InbodyReport> mqttReports = [];
  bool _isConnected = false;
  bool _isLoading = false;

  bool get isConnected => _isConnected;
  bool get isLoading => _isLoading;

  /// 初始化 MQTT 並訂閱使用者專屬 Topic
  Future<void> initMqtt(String uid) async {
    // Legacy ingestion requires explicit opt-in and a caller-configured client.
    // The normal app never connects to a public broker.
    if (!enabled ||
        _client == null ||
        _isDisposed ||
        _isConnected ||
        _isLoading) {
      return;
    }

    _isLoading = true;
    mqttReports.clear(); // 清除舊數據
    _notifyIfActive();

    final String uniqueId =
        'flutter_${uid}_${DateTime.now().millisecondsSinceEpoch}';

    // ✅ 自定義 Topic 路徑 (發送端 MQTTX 需對應此路徑)
    final String userTopic = "inbody/users/$uid/data";
    final String statusTopic = "inbody/users/$uid/status";

    _client.keepAlivePeriod = 20;

    // ✅ 設定連線訊息與遺囑 (Last Will)
    final connMessage = MqttConnectMessage()
        .withClientIdentifier(uniqueId)
        .startClean()
        .withWillTopic(statusTopic) // 如果斷線，自動發布到 status 主題
        .withWillMessage('offline')
        .withWillQos(MqttQos.atLeastOnce)
        .withWillRetain();

    _client.connectionMessage = connMessage;

    _client.onDisconnected = () {
      _isConnected = false;
      _notifyIfActive();
      developer.log("MQTT disconnected", name: "mqtt.provider");
    };

    try {
      await _client.connect();
      if (_isDisposed || !_isLoading) {
        _client.disconnect();
        return;
      }
      _isConnected = true;

      // ✅ 訂閱自定義 Topic
      _client.subscribe(userTopic, MqttQos.atLeastOnce);

      // 連線後發布一個在線狀態 (選配)
      final builder = MqttClientPayloadBuilder();
      builder.addString('online');
      _client.publishMessage(
        statusTopic,
        MqttQos.atLeastOnce,
        builder.payload!,
        retain: true,
      );

      _updatesSubscription?.cancel();
      _updatesSubscription = _client.updates!.listen((
        List<MqttReceivedMessage<MqttMessage>> c,
      ) {
        if (!enabled || _isDisposed || !_isConnected || c.isEmpty) return;
        final MqttPublishMessage recMess = c[0].payload as MqttPublishMessage;
        final String pt = MqttPublishPayload.bytesToStringAsString(
          recMess.payload.message,
        );

        // 收到數據，傳入 uid 進行儲存
        _handleIncomingJson(pt, uid);
      });
    } catch (_) {
      developer.log("MQTT connection failed", name: "mqtt.provider");
      _isConnected = false;
    } finally {
      _isLoading = false;
      _notifyIfActive();
    }
  }

  void _handleIncomingJson(String rawJson, String uid) async {
    if (!enabled || _isDisposed || !_isConnected) return;
    try {
      final Map<String, dynamic> data = jsonDecode(rawJson);

      final newReport = InbodyReport.fromMap(
        "mqtt_${DateTime.now().millisecondsSinceEpoch}",
        data,
      );

      mqttReports.insert(0, newReport);
      _notifyIfActive();

      // ✅ 自動儲存到 Firestore
      await _firestoreService.addReport(uid, newReport);
      developer.log("✅ Auto-saved report to Firestore", name: "mqtt.provider");
    } catch (_) {
      developer.log("MQTT report processing failed", name: "mqtt.provider");
    }
  }

  void disconnect() {
    _isLoading = false;
    _updatesSubscription?.cancel();
    _updatesSubscription = null;
    _client?.disconnect();
    _isConnected = false;
    _notifyIfActive();
  }

  void _notifyIfActive() {
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    _isConnected = false;
    _updatesSubscription?.cancel();
    _client?.disconnect();
    super.dispose();
  }
}
