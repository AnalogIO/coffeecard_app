import 'dart:async';

import 'package:chopper/chopper.dart';
import 'package:coffeecard/cubits/authentication/authentication_cubit.dart';
import 'package:coffeecard/data/repositories/v1/account_repository.dart';
import 'package:coffeecard/data/storage/secure_storage.dart';
import 'package:get_it/get_it.dart';

class ReactivationAuthenticator extends Authenticator {
  final GetIt serviceLocator;

  static DateTime? tokenRefreshedAt;
  static const Duration debounce = Duration(seconds: 10);
  static bool _refreshInProgress = false;

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
      // someone is updating the token, read it from the store and retry
      if (_refreshInProgress) {
        // FIXME: possible to read an outdated token? if so, how to fix?
        final refreshedToken = await secureStorage.readToken();
        if (refreshedToken == null) return null;

        return request.copyWith(
            headers: _updateHeadersWithToken(request.headers, refreshedToken));
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
    if (_refreshInProgress) return null;
    final email = await secureStorage.readEmail();
    final passcode = await secureStorage.readPasscode();

    if (email != null && passcode != null) {
      final accountRepository = serviceLocator.get<AccountRepository>();

      _refreshInProgress = true;
      // this call may return 401 which triggers a recursive call, use a guard
      final either = await accountRepository.login(
        email,
        passcode,
      );

      if (either.isRight) {
        // refresh succeeded, update the token in secure storage
        tokenRefreshedAt = DateTime.now();

        final token = either.right.token;
        final bearerToken = 'Bearer ${either.right.token}';
        await secureStorage.updateToken(token);
        _refreshInProgress = false;

        return request.copyWith(
          headers: _updateHeadersWithToken(request.headers, bearerToken),
        );
      } else {
        // refresh failed, sign the user out
        _evict();
      }
    }
    return null;
  }
}
