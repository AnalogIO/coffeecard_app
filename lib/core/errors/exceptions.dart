import 'package:chopper/chopper.dart';

class ServerException implements Exception {
  final String error;

  ServerException({required this.error});

  ServerException.fromResponse(Response response) : error = response.bodyString;
}

class LocalStorageException implements Exception {}
