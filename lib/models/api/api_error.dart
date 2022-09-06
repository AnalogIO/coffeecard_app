class ApiError implements Exception {
  ApiError(this.message);
  final String message;
}
