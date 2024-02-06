import 'dart:async';

import 'package:chopper/chopper.dart' as chopper;
import 'package:coffeecard/features/authentication.dart';

/// An interceptor that adds the Authorization header to the request if the user
/// is authenticated.
class AuthenticationInterceptor implements chopper.RequestInterceptor {
  AuthenticationInterceptor(this.repository);

  final AuthenticationRepository repository;

  @override
  FutureOr<chopper.Request> onRequest(chopper.Request originalRequest) {
    return repository
        .getAuthenticationToken()
        .map(originalRequest.withBearerToken)
        .getOrElse(() => originalRequest)
        .run();
  }
}