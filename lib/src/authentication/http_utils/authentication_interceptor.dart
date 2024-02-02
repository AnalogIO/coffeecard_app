import 'dart:async';

import 'package:chopper/chopper.dart' as chopper;
import 'package:coffeecard/features/authentication.dart';

/// An interceptor that adds the Authorization header to the request if the user
/// is authenticated.
class AuthenticationInterceptor implements chopper.RequestInterceptor {
  AuthenticationInterceptor(this.repository);

  final AuthenticationRepository repository;

  @override
  FutureOr<chopper.Request> onRequest(chopper.Request request) {
    return repository.getAuthenticationInfo().match(
      () => request,
      (authenticationInfo) {
        final updatedHeaders = Map.of(request.headers);
        updatedHeaders['Authorization'] = 'Bearer ${authenticationInfo.token}';
        return request.copyWith(headers: updatedHeaders);
      },
    ).run();
  }
}
