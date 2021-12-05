import 'package:dio/dio.dart';

// TODO Depend on ApiException class rather than string based parsing
String getDIOError(DioError error) {
  final String? errorMessage = error.response?.data['message'] as String?;
  return errorMessage ?? 'Unknown error';
}
