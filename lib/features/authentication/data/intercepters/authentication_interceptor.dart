import 'dart:async';

import 'package:chopper/chopper.dart';
import 'package:coffeecard/features/authentication/data/datasources/authentication_local_data_source.dart';

class AuthenticationInterceptor implements Interceptor {
  final AuthenticationLocalDataSource localDataSource;

  AuthenticationInterceptor(this.localDataSource);

  /// Try retrieve authentication token from storage and add authentication header if exists
  @override
  FutureOr<Response<Body>> intercept<Body>(Chain<Body> chain) async {
    final user = await localDataSource.getAuthenticatedUser();
    final newRequest = user.match(
      () => chain.request,
      (user) => applyHeader(
        chain.request,
        'Authorization',
        'Bearer ${user.token}',
      ),
    );
    return chain.proceed(newRequest);
  }
}
