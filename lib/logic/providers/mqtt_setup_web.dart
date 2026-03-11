import 'package:mqtt_client/mqtt_browser_client.dart';
import 'package:mqtt_client/mqtt_client.dart';

MqttClient getMqttClient(String broker, String clientId) {
  // Web 使用 BrowserClient + WebSocket (Port 8083)
  final client = MqttBrowserClient('ws://$broker', clientId);
  client.port = 8083;
  return client;
}
