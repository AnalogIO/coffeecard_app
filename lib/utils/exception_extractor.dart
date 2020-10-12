import 'package:dio/dio.dart';

// TODO Depend on ApiException class rather than string based parsing
String getDIOError(DioError error) {
  final Map<String, dynamic> errorMessage = error.response.data as Map<String, dynamic>;
  return errorMessage["message"] as String;
}
