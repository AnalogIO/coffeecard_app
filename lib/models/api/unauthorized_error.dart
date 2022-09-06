class UnauthorizedError implements Exception {
  UnauthorizedError(this.message);
  final String message;
}
