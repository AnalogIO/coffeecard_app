class UnauthorizedError implements Exception {
  const UnauthorizedError(this.message);
  final String message;
}
