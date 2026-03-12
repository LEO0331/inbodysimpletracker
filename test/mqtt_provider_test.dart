import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:typed_data/typed_buffers.dart';
import 'package:inbodysimpletracker/logic/providers/mqtt_provider.dart';
import 'package:inbodysimpletracker/data/services/firestore_service.dart';
import 'package:inbodysimpletracker/data/models/inbody_report.dart';

class MockFirestoreService extends Mock implements FirestoreService {}
class MockMqttClient extends Mock implements MqttClient {}
class MockMqttPublishMessage extends Mock implements MqttPublishMessage {}
class MockMqttPublishPayload extends Mock implements MqttPublishPayload {}

void main() {
  late MockFirestoreService mockFirestore;
  late MockMqttClient mockClient;
  late MqttProvider mqttProvider;
  late StreamController<List<MqttReceivedMessage<MqttMessage>>> updatesController;

  setUpAll(() {
    registerFallbackValue(InbodyReport(
      id: '',
      reportDate: DateTime.now(),
      weight: 0,
      bodyFatPercent: 0,
      muscleMass: 0,
      visceralFat: 0,
    ));
    registerFallbackValue(MqttQos.atLeastOnce);
    registerFallbackValue(Uint8Buffer());
  });

  setUp(() {
    mockFirestore = MockFirestoreService();
    mockClient = MockMqttClient();
    updatesController = StreamController<List<MqttReceivedMessage<MqttMessage>>>();
    mqttProvider = MqttProvider(firestoreService: mockFirestore, client: mockClient);
    
    when(() => mockClient.updates).thenAnswer((_) => updatesController.stream);
    when(() => mockClient.connect()).thenAnswer((_) async => MqttClientConnectionStatus());
    when(() => mockClient.subscribe(any(), any())).thenReturn(null);
    when(() => mockClient.publishMessage(any(), any(), any(), retain: any(named: 'retain'))).thenReturn(0);
    when(() => mockClient.disconnect()).thenAnswer((_) {});
  });

  tearDown(() {
    updatesController.close();
  });

  group('MqttProvider Unit Tests', () {
    test('initMqtt should connect and subscribe', () async {
      await mqttProvider.initMqtt('uid_123');
      expect(mqttProvider.isConnected, isTrue);
    });

    test('should handle incoming MQTT message and save to firestore', () async {
      when(() => mockFirestore.addReport(any(), any())).thenAnswer((_) async => {});
      
      await mqttProvider.initMqtt('uid_123');

      final jsonStr = jsonEncode({
        'weight': 70.0,
        'bodyFatPercent': 15.0,
        'muscleMass': 35.0,
        'visceralFat': 5.0,
      });
      final bytes = Uint8List.fromList(utf8.encode(jsonStr));
      final buffer = Uint8Buffer()..addAll(bytes);
      
      final mockPayload = MockMqttPublishPayload();
      when(() => mockPayload.message).thenReturn(buffer);
      
      final mockPublishMessage = MockMqttPublishMessage();
      when(() => mockPublishMessage.payload).thenReturn(mockPayload);
      
      final receivedMessage = MqttReceivedMessage<MqttMessage>('topic', mockPublishMessage);
      
      updatesController.add([receivedMessage]);
      
      await Future.delayed(const Duration(milliseconds: 100));

      expect(mqttProvider.mqttReports.length, 1);
      verify(() => mockFirestore.addReport('uid_123', any())).called(1);
    });

    test('should handle invalid JSON message gracefully', () async {
      await mqttProvider.initMqtt('uid_123');

      final bytes = Uint8List.fromList(utf8.encode('invalid json'));
      final buffer = Uint8Buffer()..addAll(bytes);
      
      final mockPayload = MockMqttPublishPayload();
      when(() => mockPayload.message).thenReturn(buffer);
      
      final mockPublishMessage = MockMqttPublishMessage();
      when(() => mockPublishMessage.payload).thenReturn(mockPayload);
      
      final receivedMessage = MqttReceivedMessage<MqttMessage>('topic', mockPublishMessage);
      
      updatesController.add([receivedMessage]);
      await Future.delayed(const Duration(milliseconds: 100));

      expect(mqttProvider.mqttReports.isEmpty, isTrue);
    });
  });
}
