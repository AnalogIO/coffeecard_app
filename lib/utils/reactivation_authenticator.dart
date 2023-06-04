import 'dart:async';

import 'package:chopper/chopper.dart';
import 'package:coffeecard/core/data/datasources/account_remote_data_source.dart';
import 'package:coffeecard/cubits/authentication/authentication_cubit.dart';
import 'package:coffeecard/data/storage/secure_storage.dart';
import 'package:coffeecard/generated/api/coffeecard_api.models.swagger.dart'
    show LoginDto;
import 'package:coffeecard/utils/throttler.dart';
import 'package:fpdart/fpdart.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

class ReactivationAuthenticator extends Authenticator {
  /// Whether [initialize] has been called.
  bool _ready = false;
  late final AccountRemoteDataSource _accountRemoteDataSource;

  final SecureStorage _secureStorage;
  final AuthenticationCubit _authenticationCubit;
  final Logger _logger;

  final _throttler = Throttler<Option<String>>();

  /// Creates a new [ReactivationAuthenticator] instance.
  ///
  /// This instance is not ready to be used. Call [initialize] before using it.
  ReactivationAuthenticator.uninitialized({required GetIt serviceLocator})
      : _secureStorage = serviceLocator<SecureStorage>(),
        _authenticationCubit = serviceLocator<AuthenticationCubit>(),
        _logger = serviceLocator<Logger>();

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
      final minimumDuration = Future<void>.delayed(const Duration(seconds: 1));
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
        final email = await _secureStorage.readEmail();
        final encodedPasscode = await _secureStorage.readEncodedPasscode();
        if (email == null || encodedPasscode == null) {
          return none();
        }

        // Attempt to log in with the stored credentials.
        // This login call may return 401 if the stored credentials are invalid;
        // recursive calls to [authenticate] are blocked by a check in the
        // [authenticate] method.
        final either =
            await _accountRemoteDataSource.login(email, encodedPasscode);

        return Option.fromEither(either).map((user) => user.token);
      },
    );
  }

  /// Saves the [token] in [SecureStorage]
  /// or signs out the user if the [token] is [None].
  Task<Unit> _saveOrEvict(Option<String> token) {
    return token.match(
      () {
        _logRefreshTokenFailed();
        return Task(_authenticationCubit.unauthenticated);
      },
      (token) {
        _logRefreshTokenSucceeded();
        return Task(() => _secureStorage.updateToken(token));
      },
    ).map((_) => unit);
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
