import 'dart:async';

import 'package:chopper/chopper.dart';
import 'package:coffeecard/cubits/authentication/authentication_cubit.dart';
import 'package:coffeecard/data/repositories/shared/account_repository.dart';
import 'package:coffeecard/data/storage/secure_storage.dart';
import 'package:coffeecard/utils/mutex.dart';
import 'package:coffeecard/utils/throttler.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

class ReactivationAuthenticator extends Authenticator {
  final GetIt _serviceLocator;
  final SecureStorage _secureStorage;
  final AuthenticationCubit _authenticationCubit;
  final Logger _logger;

  final _mutex = Mutex();
  final _throttler = Throttler(duration: const Duration(seconds: 2));

  ReactivationAuthenticator(this._serviceLocator)
      : _secureStorage = _serviceLocator<SecureStorage>(),
        _authenticationCubit = _serviceLocator<AuthenticationCubit>(),
        _logger = _serviceLocator<Logger>();

  Future<void> _evict() => _authenticationCubit.unauthenticated();

  Map<String, String> _updateHeadersWithToken(
    Map<String, String> headers,
    String token,
  ) {
    return headers
      ..update(
        'Authorization',
        (String _) => token,
        ifAbsent: () => token,
      );
  }

  void _log(Request request, Response response) {
    _logger.d(
      '${request.method} ${request.url} ${response.statusCode}\n${response.bodyString}',
    );
  }

  @override
  FutureOr<Request?> authenticate(
    Request request,
    Response response, [
    Request? _,
  ]) async {
    _log(request, response);
    if (response.statusCode != 401) {
      return null;
    }
    return !_mutex.isLocked
        // No one is updating the token, so we do it
        // (throttle the call to avoid refreshing the token multiple times if
        // requests happen at the same time)
        ? _throttler.run(() => _mutex.run(() => refreshToken(request)))
        // Someone else is updating the token, so we wait for it to finish
        // and read the new token from secure storage
        : _mutex.runWithoutLock(() async {
            final refreshedToken = await _secureStorage.readToken();
            if (refreshedToken == null) {
              return null;
            }
            return request.copyWith(
              headers: _updateHeadersWithToken(request.headers, refreshedToken),
            );
          });
  }

  Future<Request?> refreshToken(Request request) async {
    final email = await _secureStorage.readEmail();
    final encodedPasscode = await _secureStorage.readEncodedPasscode();

    if (email == null || encodedPasscode == null) {
      //User is not logged in
      return null;
    }
    final accountRepository = _serviceLocator.get<AccountRepository>();

    // this call may return 401 which triggers a recursive call, use a guard
    final either = await accountRepository.login(email, encodedPasscode);

    return either.fold(
      (_) {
        // refresh failed, sign the user out
        _evict();
        return null;
      },
      (user) async {
        // refresh succeeded, update the token in secure storage
        final token = user.token;
        final bearerToken = 'Bearer ${user.token}';
        await _secureStorage.updateToken(token);

        return request.copyWith(
          headers: _updateHeadersWithToken(request.headers, bearerToken),
        );
      },
    );
  }
}
