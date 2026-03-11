import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:mqtt_client/mqtt_client.dart';

MqttClient getMqttClient(String broker, String clientId) {
  // Mobile 使用 ServerClient + TCP (Port 1883)
  final client = MqttServerClient(broker, clientId);
  client.port = 1883;
  return client;
}
