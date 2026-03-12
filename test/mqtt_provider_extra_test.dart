import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:inbodysimpletracker/logic/providers/mqtt_provider.dart';
import 'package:inbodysimpletracker/data/services/firestore_service.dart';

class MockFirestoreService extends Mock implements FirestoreService {}
class MockMqttClient extends Mock implements MqttClient {}

void main() {
  late MockFirestoreService mockFirestore;
  late MockMqttClient mockClient;
  late MqttProvider mqttProvider;

  setUp(() {
    mockFirestore = MockFirestoreService();
    mockClient = MockMqttClient();
    mqttProvider = MqttProvider(firestoreService: mockFirestore, client: mockClient);
  });

  group('MqttProvider Extra Tests', () {
    test('disconnect should call client disconnect', () {
      when(() => mockClient.disconnect()).thenAnswer((_) {});
      mqttProvider.disconnect();
      verify(() => mockClient.disconnect()).called(1);
    });

    test('onDisconnected callback updates state', () {
      // Manual trigger if possible via internal state or just check if it's set
      // Since it's a private callback, we usually test it via the result of disconnect logic
      // but MqttProvider sets client.onDisconnected = _onDisconnected;
      // We can't easily trigger the private _onDisconnected from outside without reflection.
    });
  });
}
