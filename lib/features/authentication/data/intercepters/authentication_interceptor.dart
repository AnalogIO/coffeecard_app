import 'dart:async';

import 'package:chopper/chopper.dart';
import 'package:coffeecard/features/authentication/data/datasources/authentication_local_data_source.dart';

class AuthenticationInterceptor implements RequestInterceptor {
  final AuthenticationLocalDataSource localDataSource;

  AuthenticationInterceptor(this.localDataSource);

  /// Try retrieve authentication token from storage and add authentication header if exists
  @override
  FutureOr<Request> onRequest(Request request) async {
    final user = await localDataSource.getAuthenticatedUser();

    return user.match(() => request, (user) {
      final updatedHeaders = Map.of(request.headers);
      updatedHeaders['Authorization'] = 'Bearer ${user.token}';

      return request.copyWith(headers: updatedHeaders);
    });
  }
}
