import 'dart:async';
import 'dart:developer' as developer;

import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttService {
  late MqttServerClient client;
  StreamSubscription<List<MqttReceivedMessage<MqttMessage>>>? _subscription;

  Future<void> connect() async {
    // 這裡使用公共測試 Broker: broker.emqx.io
    client = MqttServerClient(
      'broker.emqx.io',
      'flutter_client_${DateTime.now().millisecondsSinceEpoch}',
    );
    client.port = 1883;
    client.keepAlivePeriod = 20;

    final connMessage = MqttConnectMessage()
        .withClientIdentifier('flutter_client')
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);
    client.connectionMessage = connMessage;

    try {
      await client.connect();
      developer.log('MQTT connected', name: 'mqtt.service');
    } catch (e) {
      developer.log('MQTT connection failed', name: 'mqtt.service', error: e);
      client.disconnect();
    }

    // 訂閱主題
    client.subscribe("inbody/data", MqttQos.atLeastOnce);

    // 監聽訊息
    _subscription?.cancel();
    _subscription = client.updates!.listen((
      List<MqttReceivedMessage<MqttMessage>> c,
    ) {
      final MqttPublishMessage recMess = c[0].payload as MqttPublishMessage;
      final String pt = MqttPublishPayload.bytesToStringAsString(
        recMess.payload.message,
      );
      developer.log(
        'MQTT message received on ${c[0].topic}: $pt',
        name: 'mqtt.service',
      );
    });
  }

  void publish(String topic, String message) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);
    client.publishMessage(topic, MqttQos.exactlyOnce, builder.payload!);
  }

  void disconnect() {
    _subscription?.cancel();
    client.disconnect();
  }
}
