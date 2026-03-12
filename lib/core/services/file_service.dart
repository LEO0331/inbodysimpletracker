import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'ocr_service.dart';

class FileService {
  final TextRecognizer _textRecognizer;

  FileService({TextRecognizer? textRecognizer})
      : _textRecognizer = textRecognizer ?? TextRecognizer();

  Future<String> recognizeImage(Uint8List bytes, String? filePath) async {
    if (kIsWeb) {
      return await webOcrRecognize(bytes);
    } else {
      if (filePath != null) {
        final inputImage = InputImage.fromFilePath(filePath);
        final RecognizedText result = await _textRecognizer.processImage(inputImage);
        return result.text;
      }
      return "Error: Missing file path on mobile.";
    }
  }

  Future<String> extractPdfText(Uint8List bytes) async {
    final PdfDocument document = PdfDocument(inputBytes: bytes);
    final PdfTextExtractor textExtractor = PdfTextExtractor(document);
    String text = textExtractor.extractText();
    document.dispose();
    return text;
  }

  void dispose() {
    if (!kIsWeb) {
      _textRecognizer.close();
    }
  }
}
