import 'dart:async';

import 'package:chopper/chopper.dart' as chopper;
import 'package:coffeecard/core/throttler.dart';
import 'package:coffeecard/features/authentication.dart';
import 'package:coffeecard/features/login/data/datasources/account_remote_data_source.dart';
import 'package:coffeecard/generated/api/coffeecard_api.models.swagger.dart'
    show LoginDto;
import 'package:fpdart/fpdart.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

class RetryAuthenticator extends chopper.Authenticator {
  /// Creates a new [RetryAuthenticator] instance.
  ///
  /// This instance is not ready to be used. Call [initialize] before using it.
  RetryAuthenticator.uninitialized({required GetIt serviceLocator})
      : _repository = serviceLocator(),
        _cubit = serviceLocator(),
        _logger = serviceLocator();

  final AuthenticationRepository _repository;
  final AuthenticationCubit _cubit;
  final Logger _logger;

  // Will be set by [initialize].
  late final AccountRemoteDataSource _accountRemoteDataSource;

  final _throttler = Throttler<Option<AuthenticationInfo>>();
  bool _initialized = false;

  /// Initializes the [RetryAuthenticator] by providing the
  /// [AccountRemoteDataSource] to use.
  ///
  /// This method must be called before the [RetryAuthenticator] is used.
  void initialize(AccountRemoteDataSource accountRemoteDataSource) {
    _initialized = true;
    _accountRemoteDataSource = accountRemoteDataSource;
  }

  @override
  Future<chopper.Request?> authenticate(
    chopper.Request request,
    chopper.Response response, [
    chopper.Request? _,
  ]) {
    // If the [ReactivationAuthenticator] is not ready, an error is thrown.
    assert(
      _initialized,
      'ReactivationAuthenticator is not ready. '
      'Call initialize() before using it.',
    );

    // If the response is not unauthorized, we don't need to do anything.
    if (response.statusCode != 401) {
      return Future.value();
    }

    // If the request is a unauthorized login request (token refresh request),
    // we should not try to refresh the token.
    // Otherwise, we would end up in an infinite loop.
    if (request.body is LoginDto) {
      return Future.value();
    }

    // Try to refresh the token.
    final maybeNewToken = Task(() async {
      // Set a minimum duration for the token refresh to allow for throttling.
      final minimumDuration = Future.delayed(const Duration(milliseconds: 250));

      final maybeNewAuthenticationInfo = await _retryLogin(request).run();
      await minimumDuration;

      // Side effect: save the new token or evict the user.
      final _ = maybeNewAuthenticationInfo.match(
        _evictUser,
        _saveNewAuthenticationInfo,
      );
      return maybeNewAuthenticationInfo;
    }).runThrottled(_throttler);

    final maybeNewRequest = TaskOption(() => maybeNewToken).match(
      () => null,
      (info) => request..headers['Authorization'] = 'Bearer ${info.token}',
    );

    return maybeNewRequest.run();
  }

  /// Attempt to retrieve new [AuthenticationInfo] by logging in with the
  /// stored credentials.
  TaskOption<AuthenticationInfo> _retryLogin(chopper.Request request) {
    _logger.d(
      'Token refresh triggered by request:\n\t${request.method} ${request.url}',
    );

    return _repository.getAuthenticationInfo().flatMap(
          (i) => TaskOption(
            () async => Option.fromEither(
              // Attempt to log in with the stored credentials.
              // The login call may return 401 if the stored credentials are
              // invalid; recursive calls to [authenticate] are blocked by a
              // check in the [authenticate] method.
              await _accountRemoteDataSource.login(i.email, i.encodedPasscode),
              // TODO: Change above method to return a TaskOption.
            ),
          ),
        );
  }

  Task<Unit> _saveNewAuthenticationInfo(AuthenticationInfo newInfo) {
    return _repository
        .saveAuthenticationInfo(newInfo)
        .map((_) => _logger.d('Successfully refreshed token.'))
        .map((_) => unit);
  }

  Task<Unit> _evictUser() {
    _logger.e('Failed to refresh token. Signing out.');
    _cubit.unauthenticated();
    return Task.of(unit);
  }
}
