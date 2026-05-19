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
      const text =
          'Weight 80.0 Body  Fat 20.0 Muscle Mass:30.5 Visceral Fat:10';

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

    test('Should parse Chinese InBody 270 OCR text from May sample', () {
      const text = '''
        InBody270
        檢測日期/時間 2026.05.18. 20:08
        身體組成分析
        身體總水重 36.6 L
        蛋白質重 9.8 kg
        礦物質重 3.50 kg
        體脂肪重 21.4 kg
        體重 71.3 kg
        肌肉脂肪分析
        骨骼肌重 27.4 kg
        肥胖分析
        體脂肪率 30.1 %
        內臟脂肪級別 級別 9
      ''';

      final metrics = InbodyParser.parse(text);

      expect(metrics['weight'], 71.3);
      expect(metrics['bodyFatPercent'], 30.1);
      expect(metrics['muscleMass'], 27.4);
      expect(metrics['visceralFat'], 9.0);
      expect(metrics['reportDate'], '2026-05-18T20:08:00.000');
    });

    test('Should parse Chinese InBody 270 OCR text from April sample', () {
      const text = '''
        InBody270
        檢測日期/時間 2026.04.07. 20:09
        體重 72.4 kg
        骨骼肌重 27.3 kg
        體脂肪重 22.7 kg
        BMI 24.2
        PBF 體脂肪率 31.4 %
        內臟脂肪級別 10
        體重控制 目標體重 65.8 kg
      ''';

      final metrics = InbodyParser.parse(text);

      expect(metrics['weight'], 72.4);
      expect(metrics['bodyFatPercent'], 31.4);
      expect(metrics['muscleMass'], 27.3);
      expect(metrics['visceralFat'], 10.0);
      expect(metrics['reportDate'], '2026-04-07T20:09:00.000');
    });
  });
}
