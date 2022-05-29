class UnauthorizedError implements Exception {
  final String message;

  UnauthorizedError(this.message);

  @override
  String toString() => message;
}
