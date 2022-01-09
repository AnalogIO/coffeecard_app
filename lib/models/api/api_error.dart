class ApiError implements Exception {
  final String errorMessage;

  ApiError(this.errorMessage);

  @override
  String toString() {
    return 'ApiError{errorMessage: $errorMessage}';
  }
}
