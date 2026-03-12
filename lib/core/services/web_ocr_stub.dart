import 'dart:typed_data';

/// Stub for non-web platforms. This should never be called on mobile.
Future<String> webOcrRecognize(Uint8List imageBytes) async {
  throw UnsupportedError('webOcrRecognize is only supported on web');
}
