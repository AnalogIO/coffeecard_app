import 'dart:async';

import 'package:chopper/chopper.dart';
import 'package:coffeecard/cubits/authentication/authentication_cubit.dart';
import 'package:coffeecard/data/repositories/shared/account_repository.dart';
import 'package:coffeecard/data/storage/secure_storage.dart';
import 'package:coffeecard/utils/mutex.dart';
import 'package:get_it/get_it.dart';

class ReactivationAuthenticator extends Authenticator {
  final GetIt serviceLocator;
  static const Duration debounce = Duration(seconds: 10);

  DateTime? tokenRefreshedAt;
  Mutex mutex = Mutex();

  late SecureStorage secureStorage;
  late AuthenticationCubit authenticationCubit;

  ReactivationAuthenticator(this.serviceLocator) {
    secureStorage = serviceLocator.get<SecureStorage>();
    authenticationCubit = serviceLocator.get<AuthenticationCubit>();
  }

  bool _canRefreshToken() =>
      tokenRefreshedAt == null ||
      tokenRefreshedAt!.difference(DateTime.now()) < debounce;

  Future<void> _evict() async => authenticationCubit.unauthenticated();

  Map<String, String> _updateHeadersWithToken(
    Map<String, String> headers,
    String token,
  ) {
    headers.update(
      'Authorization',
      (String _) => token,
      ifAbsent: () => token,
    );
    return headers;
  }

  @override
  FutureOr<Request?> authenticate(
    Request request,
    Response response, [
    Request? originalRequest,
  ]) async {
    if (response.statusCode == 401) {
      if (mutex.isLocked()) {
        // someone is updating the token, wait until they are done and read it
        await mutex.wait();
        final refreshedToken = await secureStorage.readToken();
        return refreshedToken != null
            ? request.copyWith(
                headers:
                    _updateHeadersWithToken(request.headers, refreshedToken),
              )
            : null;
      }

      // avoid refreshing the token multiple times if requests happen at the same time
      if (!_canRefreshToken()) {
        return null;
      }

      return await refreshToken(request, response);
    }
    return null;
  }

  Future<Request?> refreshToken(
    Request request,
    Response response,
  ) async {
    final email = await secureStorage.readEmail();
    final passcode = await secureStorage.readPasscode();

    if (email != null && passcode != null) {
      final accountRepository = serviceLocator.get<AccountRepository>();

      mutex.lock();

      // this call may return 401 which triggers a recursive call, use a guard
      try {
        final either = await accountRepository.login(email, passcode);

        if (either.isRight) {
          // refresh succeeded, update the token in secure storage
          tokenRefreshedAt = DateTime.now();

          final token = either.right.token;
          final bearerToken = 'Bearer ${either.right.token}';
          await secureStorage.updateToken(token);

          return request.copyWith(
            headers: _updateHeadersWithToken(request.headers, bearerToken),
          );
        } else {
          // refresh failed, sign the user out
          _evict();
        }
      } finally {
        mutex.unlock();
      }
    }
    return null;
  }
}
