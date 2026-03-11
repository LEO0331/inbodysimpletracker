import 'package:mqtt_client/mqtt_browser_client.dart';
import 'package:mqtt_client/mqtt_client.dart';

MqttClient getMqttClient(String broker, String clientId) {
  // ✅ 修正：使用 wss 並明確指定路徑為 /mqtt
  final client = MqttBrowserClient('wss://$broker/mqtt', clientId);
  client.port = 8084; 
  
  // ✅ 關鍵：設定 WebSocket 協定，這能解決 404Handshake 錯誤
  client.websocketProtocols = MqttClientConstants.protocolsSingleDefault;

  return client;
}
