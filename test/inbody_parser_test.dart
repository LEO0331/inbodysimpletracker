import 'package:flutter_test/flutter_test.dart';
import 'package:inbodysimpletracker/core/utils/inbody_parser.dart';

void main() {
  group('InbodyParser Unit Tests', () {
    test('Should correctly parse metrics from standard OCR text', () {
      const text = '''
        Height: 175.0 cm
        Weight: 72.5 kg
        Body Fat: 15.5 %
        Muscle Mass: 36.2 kg
        Visceral Fat: 6
      ''';

      final metrics = InbodyParser.parse(text);

      expect(metrics['weight'], 72.5);
      expect(metrics['bodyFatPercent'], 15.5);
      expect(metrics['muscleMass'], 36.2);
      expect(metrics['visceralFat'], 6.0);
      expect(metrics['reportDate'], isA<String>());
    });

    test('Should handle text with different prefixes/spacing', () {
      const text = 'Weight 80.0 Body  Fat 20.0 Muscle Mass:30.5 Visceral Fat:10';
      
      final metrics = InbodyParser.parse(text);

      expect(metrics['weight'], 80.0);
      expect(metrics['bodyFatPercent'], 20.0);
      expect(metrics['muscleMass'], 30.5);
      expect(metrics['visceralFat'], 10.0);
    });

    test('Should return 0.0 for missing metrics', () {
      const text = 'Nothing relevant here';
      
      final metrics = InbodyParser.parse(text);

      expect(metrics['weight'], 0.0);
      expect(metrics['bodyFatPercent'], 0.0);
      expect(metrics['muscleMass'], 0.0);
      expect(metrics['visceralFat'], 0.0);
    });

    test('Should handle complex OCR text with noise', () {
      const text = '''
        Random Header info
        Model: XC-200
        Weight: 68.4kg
        Something else
        Body Fat: 12.3%
        Muscle Mass: 33.0kg
        Visceral Fat: 4
        Footer text 2024
      ''';
      
      final metrics = InbodyParser.parse(text);

      expect(metrics['weight'], 68.4);
      expect(metrics['bodyFatPercent'], 12.3);
      expect(metrics['muscleMass'], 33.0);
      expect(metrics['visceralFat'], 4.0);
    });
  });
}
