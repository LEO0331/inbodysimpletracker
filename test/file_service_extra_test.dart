import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:inbodysimpletracker/core/services/file_service.dart';

class MockTextRecognizer extends Mock implements TextRecognizer {}

void main() {
  late MockTextRecognizer mockRecognizer;
  late FileService fileService;

  setUp(() {
    mockRecognizer = MockTextRecognizer();
    when(() => mockRecognizer.close()).thenAnswer((_) async {});
    fileService = FileService(textRecognizer: mockRecognizer);
  });

  group('FileService Unit Tests', () {
    test('dispose calls recognizer close', () {
       fileService.dispose();
       verify(() => mockRecognizer.close()).called(1);
    });

    test('Constructor works and dispose is safe', () {
       final service = FileService(textRecognizer: mockRecognizer);
       service.dispose();
       // Should not throw
    });
  });
}
