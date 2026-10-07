/// A copy failure whose owned destination could not be cleaned up.
class LocalVideoCopyException implements Exception {
  final String localReference;

  const LocalVideoCopyException(this.localReference);

  @override
  String toString() =>
      'Video copy failed and a local copy may remain at $localReference.';
}
