import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:inbodysimpletracker/core/services/file_service.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class MockTextRecognizer extends Mock implements TextRecognizer {}

void main() {
  late FileService fileService;
  late MockTextRecognizer mockRecognizer;

  setUp(() {
    mockRecognizer = MockTextRecognizer();
    fileService = FileService(textRecognizer: mockRecognizer);
    
    when(() => mockRecognizer.close()).thenAnswer((_) async {});
  });

  group('FileService Unit Tests', () {
    test('dispose should call close on recognizer', () {
      fileService.dispose();
      verify(() => mockRecognizer.close()).called(1);
    });
  });
}
