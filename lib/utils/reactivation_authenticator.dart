import 'dart:async';

import 'package:chopper/chopper.dart';
import 'package:coffeecard/cubits/authentication/authentication_cubit.dart';
import 'package:coffeecard/data/repositories/v1/account_repository.dart';
import 'package:coffeecard/data/storage/secure_storage.dart';
import 'package:coffeecard/service_locator.dart';

class ReactivationAuthenticator extends Authenticator {
  final SecureStorage secureStorage;
  DateTime? tokenRefreshedAt;
  final Duration debounce = const Duration(seconds: 10);
  int _retryCount = 0;
  final int _retryLimit = 1;

  ReactivationAuthenticator(this.secureStorage);

  bool _canRefreshToken() {
    if (tokenRefreshedAt == null) {
      return true;
    } else {
      return tokenRefreshedAt!.difference(DateTime.now()) < debounce;
    }
  }

  Future<void> _evict() async {
    final authenticationCubit = sl.get<AuthenticationCubit>();
    await authenticationCubit.unauthenticated();
  }

  @override
  FutureOr<Request?> authenticate(
    Request request,
    Response response, [
    Request? originalRequest,
  ]) async {
    if (response.statusCode == 401) {
      // sign the user out
      if (_retryCount > _retryLimit) {
        _evict();
        return null;
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
    _retryCount++;

    final accountRepository = sl.get<AccountRepository>();
    final email = await secureStorage.readEmail();
    final passcode = await secureStorage.readPasscode();

    if (email != null && passcode != null) {
      // this call may return 401 which triggers a recursive call
      final either = await accountRepository.login(
        email,
        passcode,
      );

      if (either.isRight) {
        tokenRefreshedAt = DateTime.now();
        _retryCount = 0;

        final Map<String, String> updatedHeaders =
            Map<String, String>.of(request.headers);

        final token = either.right.token;
        final bearerToken = 'Bearer ${either.right.token}';
        await secureStorage.updateToken(token);

        updatedHeaders.update(
          'Authorization',
          (String _) => bearerToken,
          ifAbsent: () => bearerToken,
        );
        return request.copyWith(headers: updatedHeaders);
      }
    }
    return null;
  }
}
