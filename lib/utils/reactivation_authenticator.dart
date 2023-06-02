import 'dart:async';

import 'package:chopper/chopper.dart';
import 'package:coffeecard/cubits/authentication/authentication_cubit.dart';
import 'package:coffeecard/data/repositories/shared/account_repository.dart';
import 'package:coffeecard/data/storage/secure_storage.dart';
import 'package:coffeecard/utils/mutex.dart';
import 'package:coffeecard/utils/throttler.dart';
import 'package:fpdart/fpdart.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

class ReactivationAuthenticator extends Authenticator {
  final SecureStorage _secureStorage;
  final AuthenticationCubit _authenticationCubit;
  final AccountRepository _accountRepository;
  final Logger _logger;

  final _mutex = Mutex();
  final _throttler = Throttler<Request?>();

  /// The [throttler] parameter is exposed for testing purposes. It defaults to
  /// a new [Throttler] with a duration of [_defaultThrottleDuration].
  ReactivationAuthenticator({
    required GetIt serviceLocator,
  })  : _secureStorage = serviceLocator<SecureStorage>(),
        _authenticationCubit = serviceLocator<AuthenticationCubit>(),
        _logger = serviceLocator<Logger>(),
        _accountRepository = serviceLocator<AccountRepository>();

  @override
  Future<Request?> authenticate(
    Request request,
    Response response, [
    Request? _,
  ]) {
    // If the response is not unauthorized, we don't need to do anything.
    if (response.statusCode != 401) {
      return Future.value();
    }

    // Log the request and response
    _logUnauthorized(request, response);

    // If the response is unauthorized, we try to refresh the token.
    final requestTask = _mutex.isLocked.match(
      // No one is updating the token, so we do it
      // (throttle the call to avoid refreshing the token multiple times if
      // requests happen at the same time)
      () => _refreshToken(request).protectWith(_mutex).throttleWith(_throttler),
      // Someone else is updating the token, so we wait for it to finish
      // and read the new token from secure storage
      () => _readToken(request).protectWith(_mutex),
    );

    // Run the Task, unwrapping the Request? inside it.
    return requestTask.run();
  }

  /// Refreshes the token and returns a new request with the updated token.
  /// If the refresh fails, the user is signed out.
  ///
  /// Return null if the user is not logged in or could not be signed in with
  /// the stored credentials.
  Task<Request?> _refreshToken(Request request) {
    _logRefreshingToken(request);

    return Task(
      () async {
        // Check if user credentials are stored; if not, return None.
        final email = await _secureStorage.readEmail();
        final encodedPasscode = await _secureStorage.readEncodedPasscode();
        if (email == null || encodedPasscode == null) {
          return null;
        }

        // Attempt to log in with the stored credentials.
        // This login call may return 401 if the stored credentials are invalid;
        // recursive calls to this method are blocked by the mutex.
        final either = await _accountRepository.login(email, encodedPasscode);
        return either.match(
          (_) => _evict() as Request,
          (user) => _saveTokenAndUpdateRequestWithToken(request, user.token),
        );
      },
    );
  }

  /// Attempts to read the token from [SecureStorage]. If it exists, returns a
  /// new [Request] with the updated token.
  Task<Request?> _readToken(Request request) {
    return Task(() async {
      final token = await _secureStorage.readToken();
      return token.toOption().match(
            () => null,
            (token) => _updateRequestWithToken(request, token),
          );
    });
  }

  /// Signs out the user and returns null.
  Future<void> _evict() async {
    _logRefreshTokenFailed();
    await _authenticationCubit.unauthenticated();
  }

  /// Saved the refreshed token in secure storage and returns a new [Request]
  /// with the updated token.
  ///
  /// Used when the token is refreshed successfully.
  Future<Request> _saveTokenAndUpdateRequestWithToken(
    Request request,
    String token,
  ) async {
    _logRefreshTokenSucceeded();

    await _secureStorage.updateToken(token);
    return _updateRequestWithToken(request, 'Bearer $token');
  }

  /// Returns a new [Request] with the updated token.
  Request _updateRequestWithToken(Request request, String token) {
    return request..headers['Authorization'] = token;
  }

  /// Logs the request and response at the warning level.
  ///
  /// This is used when the response is unauthorized.
  void _logUnauthorized(Request request, Response response) {
    _logger.w(
      'Unauthorized request.\n'
      '\t${request.method} ${request.url} ${response.statusCode}\n'
      '\t${response.bodyString}',
    );
  }

  /// Logs the request at the info level.
  ///
  /// This is used when the response is unauthorized and the token is being
  /// refreshed.
  void _logRefreshingToken(Request request) {
    _logger.i(
      'Refreshing token for request:\n'
      '\t${request.method} ${request.url}',
    );
  }

  /// Logs that the refresh token call failed.
  void _logRefreshTokenFailed() {
    _logger.e('Failed to refresh token. Signing out.');
  }

  /// Logs that the refresh token call succeeded.
  void _logRefreshTokenSucceeded() {
    _logger.i('Successfully refreshed token.');
  }
}
