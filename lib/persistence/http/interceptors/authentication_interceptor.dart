import 'package:coffeecard/persistence/storage/secure_storage.dart';
import 'package:dio/dio.dart';

class AuthenticationInterceptor extends InterceptorsWrapper {
  final SecureStorage _storage;

  AuthenticationInterceptor(this._storage);

  /// Try retrieve authentication token from storage and add authentication header if found
  @override
  Future onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _storage.readToken();

    if (token != null) {
      options.headers["Authorization"] = "Bearer $token";
    }

    return super.onRequest(options);
  }
}
