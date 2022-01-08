import 'dart:async';

import 'package:chopper/chopper.dart';
import 'package:coffeecard/persistence/storage/secure_storage.dart';

class AuthenticationInterceptor extends RequestInterceptor {
  final SecureStorage _storage;

  AuthenticationInterceptor(this._storage);

  /// Try retrieve authentication token from storage and add authentication header if exists
  @override
  FutureOr<Request> onRequest(Request request) async {
    final token = await _storage.readToken();

    if (token != null) {
      final updatedHeaders = Map.of(request.headers);
      updatedHeaders['Authorization'] = 'Bearer $token';

      return request.copyWith(headers: updatedHeaders);
    }

    return request;
  }
}
