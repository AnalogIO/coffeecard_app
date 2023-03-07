import 'dart:convert';

import 'package:chopper/chopper.dart';

class ServerException implements Exception {
  final String error;

  ServerException({required this.error});

  factory ServerException.fromResponse(Response response) {
    try {
      final jsonString =
          json.decode(response.bodyString) as Map<String, dynamic>;

      return ServerException(error: jsonString['message'] as String);
    } on Exception {
      return ServerException(error: response.bodyString);
    }
  }
}

class LocalStorageException implements Exception {}
