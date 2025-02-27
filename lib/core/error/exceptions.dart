class LocalDataException implements Exception {
  final String message;

  LocalDataException(this.message);

  @override
  String toString() => message;
}
