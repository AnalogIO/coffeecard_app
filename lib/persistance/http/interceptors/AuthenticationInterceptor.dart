import 'package:coffeecard/persistance/storage/SecureStorage.dart';
import 'package:dio/dio.dart';

class AuthenticationInterceptor extends InterceptorsWrapper {
  final SecureStorage _storage;

  AuthenticationInterceptor(this._storage);

  /// Try retrieve authentication token from storage and add authentication header if found
  @override
  Future onRequest(RequestOptions options) async {
    final token = await _storage.readToken();

    if (token != null) {
      options.headers["Authorization"] = "Bearer ${token}";
    }

    return super.onRequest(options);
  }

  @override
  Future onError(DioError err) {
    return super.onError(err);
  }
}
