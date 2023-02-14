import 'dart:async';

import 'package:chopper/chopper.dart';
import 'package:coffeecard/cubits/authentication/authentication_cubit.dart';
import 'package:coffeecard/data/repositories/shared/account_repository.dart';
import 'package:coffeecard/data/storage/secure_storage.dart';
import 'package:coffeecard/utils/mutex.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

class ReactivationAuthenticator extends Authenticator {
  final GetIt serviceLocator;
  static const Duration debounce = Duration(seconds: 2);

  DateTime? tokenRefreshedAt;
  Mutex mutex = Mutex();

  late SecureStorage secureStorage;
  late AuthenticationCubit authenticationCubit;
  late Logger logger;

  ReactivationAuthenticator(this.serviceLocator) {
    secureStorage = serviceLocator.get<SecureStorage>();
    authenticationCubit = serviceLocator.get<AuthenticationCubit>();
    logger = serviceLocator.get<Logger>();
  }

  bool _canRefreshToken() =>
      tokenRefreshedAt == null ||
      DateTime.now().difference(tokenRefreshedAt!) > debounce;

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
    logger.d(
      '${request.url} ${response.statusCode}\n${response.bodyString}',
    );
    if (response.statusCode != 401) {
      return null;
    }

    if (mutex.isLocked()) {
      // someone is updating the token, wait until they are done and read it
      await mutex.wait();

      final refreshedToken = await secureStorage.readToken();

      if (refreshedToken == null) {
        return null;
      }

      return request.copyWith(
        headers: _updateHeadersWithToken(request.headers, refreshedToken),
      );
    }

    // avoid refreshing the token multiple times if requests happen at the same time
    if (_canRefreshToken()) {
      return await refreshToken(request, response);
    }

    return null;
  }

  Future<Request?> refreshToken(
    Request request,
    Response response,
  ) async {
    final email = await secureStorage.readEmail();
    final encodedPasscode = await secureStorage.readEncodedPasscode();

    if (email != null && encodedPasscode != null) {
      final accountRepository = serviceLocator.get<AccountRepository>();

      mutex.lock();

      // this call may return 401 which triggers a recursive call, use a guard
      try {
        final either = await accountRepository.login(email, encodedPasscode);

        either.fold((l) {
          // refresh failed, sign the user out
          _evict();
        }, (r) async {
          // refresh succeeded, update the token in secure storage
          tokenRefreshedAt = DateTime.now();

          final token = r.token;
          final bearerToken = 'Bearer ${r.token}';
          await secureStorage.updateToken(token);

          return request.copyWith(
            headers: _updateHeadersWithToken(request.headers, bearerToken),
          );
        });
      } finally {
        mutex.unlock();
      }
    }
    return null;
  }
}
