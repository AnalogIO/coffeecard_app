import 'dart:async';

import 'package:chopper/chopper.dart';
import 'package:coffeecard/features/authentication.dart';
import 'package:coffeecard/features/login/data/datasources/account_remote_data_source.dart';
import 'package:coffeecard/features/reactivation/data/throttler.dart';
import 'package:coffeecard/generated/api/coffeecard_api.models.swagger.dart'
    show LoginDto;
import 'package:fpdart/fpdart.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

class ReactivationAuthenticator extends Authenticator {
  /// Whether [initialize] has been called.
  bool _ready = false;
  late final AccountRemoteDataSource _accountRemoteDataSource;

  final AuthenticationLocalDataSource _authenticationLocalDataSource;
  final AuthenticationCubit _authenticationCubit;
  final Logger _logger;

  final _throttler = Throttler<Option<String>>();

  /// Creates a new [ReactivationAuthenticator] instance.
  ///
  /// This instance is not ready to be used. Call [initialize] before using it.
  ReactivationAuthenticator.uninitialized({required GetIt serviceLocator})
      : _authenticationLocalDataSource = serviceLocator(),
        _authenticationCubit = serviceLocator(),
        _logger = serviceLocator();

  /// Initializes the [ReactivationAuthenticator] by providing the
  /// [AccountRemoteDataSource] to use.
  ///
  /// This method must be called before the [ReactivationAuthenticator] is used.
  void initialize(AccountRemoteDataSource accountRemoteDataSource) {
    _ready = true;
    _accountRemoteDataSource = accountRemoteDataSource;
  }

  @override
  Future<Request?> authenticate(
    Request request,
    Response response, [
    Request? _,
  ]) {
    // If the [ReactivationAuthenticator] is not ready, an error is thrown.
    assert(
      _ready,
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
      final minimumDuration =
          Future<void>.delayed(const Duration(milliseconds: 250));
      final maybeToken = await _getNewToken(request).run();
      await minimumDuration;
      // Side effect: save the new token or evict the current token.
      final _ = _saveOrEvict(maybeToken).run();
      return maybeToken;
    }).runThrottled(_throttler);

    // Convert the [maybeNewToken] to a [Request] with the new token, or null.
    final maybeNewRequest = TaskOption(() => maybeNewToken).match(
      () => null,
      (token) => request..headers['Authorization'] = 'Bearer $token',
    );

    return maybeNewRequest.run();
  }

  /// Attempt to retrieve a new token by logging in with stored credentials.
  Task<Option<String>> _getNewToken(Request request) {
    _logRefreshingToken(request);

    return Task(
      () async {
        // Check if user credentials are stored; if not, return None.
        final user =
            await _authenticationLocalDataSource.getAuthenticatedUser();

        return user.match(
          () => none(),
          (user) async {
            // Attempt to log in with the stored credentials.
            // This login call may return 401 if the stored credentials are invalid;
            // recursive calls to [authenticate] are blocked by a check in the
            // [authenticate] method.
            final either = await _accountRemoteDataSource.login(
              user.email,
              user.encodedPasscode,
            );

            return Option.fromEither(either).map((user) => user.token);
          },
        );
      },
    );
  }

  /// Saves the [token] in [AuthenticationLocalDataSource]
  /// or signs out the user if the [token] is [None].
  Task<Unit> _saveOrEvict(Option<String> token) {
    return Task(() async {
      return token.match(
        () async {
          _logRefreshTokenFailed();
          await _authenticationCubit.unauthenticated();
          return unit;
        },
        (token) async {
          _logRefreshTokenSucceeded();
          await _authenticationLocalDataSource.updateToken(token);
          return unit;
        },
      );
    });
  }

  /// Logs that a token refresh was triggered by a request.
  void _logRefreshingToken(Request request) {
    _logger.d(
      'Token refresh triggered by request:\n'
      '\t${request.method} ${request.url}',
    );
  }

  /// Logs that the refresh token call failed.
  void _logRefreshTokenFailed() {
    _logger.e('Failed to refresh token. Signing out.');
  }

  /// Logs that the refresh token call succeeded.
  void _logRefreshTokenSucceeded() {
    _logger.d('Successfully refreshed token.');
  }
}
