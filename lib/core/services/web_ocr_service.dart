import 'dart:async';
import 'dart:convert';
import 'dart:js_interop';
import 'dart:typed_data';

@JS('ocrRecognize')
external JSPromise<JSString> _ocrRecognize(JSString base64Image);

/// Performs OCR on the given image bytes using Tesseract.js (web only).
Future<String> webOcrRecognize(Uint8List imageBytes) async {
  final base64 = base64Encode(imageBytes);
  final result = await _ocrRecognize(base64.toJS).toDart;
  return result.toDart;
}
