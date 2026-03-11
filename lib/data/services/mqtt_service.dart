import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttService {
  late MqttServerClient client;

  Future<void> connect() async {
    // 這裡使用公共測試 Broker: broker.emqx.io
    client = MqttServerClient('broker.emqx.io', 'flutter_client_${DateTime.now().ms}');
    client.port = 1883;
    client.keepAlivePeriod = 20;

    final connMessage = MqttConnectMessage()
        .withClientIdentifier('flutter_client')
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);
    client.connectionMessage = connMessage;

    try {
      await client.connect();
      print('MQTT 連線成功');
    } catch (e) {
      print('連線失敗: $e');
      client.disconnect();
    }

    // 訂閱主題
    client.subscribe("inbody/data", MqttQos.atLeastOnce);

    // 監聽訊息
    client.updates!.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final MqttPublishMessage recMess = c[0].payload as MqttPublishMessage;
      final String pt = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      print('收到訊息: 主題: ${c[0].topic}, 內容: $pt');
    });
  }

  void publish(String topic, String message) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);
    client.publishMessage(topic, MqttQos.exactlyOnce, builder.payload!);
  }
}
