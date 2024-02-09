import 'dart:async';

import 'package:chopper/chopper.dart';
import 'package:coffeecard/core/extensions/task_extensions.dart';
import 'package:coffeecard/core/throttler.dart';
import 'package:coffeecard/features/authentication.dart';
import 'package:coffeecard/features/login.dart';
import 'package:coffeecard/generated/api/coffeecard_api.models.swagger.dart'
    show LoginDto;
import 'package:fpdart/fpdart.dart';
import 'package:logger/logger.dart';

class RetryAuthenticator extends Authenticator {
  /// Creates a new [RetryAuthenticator] instance.
  ///
  /// This instance is not ready to be used. Call [initialize] before using it.
  RetryAuthenticator.uninitialized({
    required AuthenticationRepository repository,
    required AuthenticationCubit cubit,
    required Logger logger,
  })  : _repository = repository,
        _cubit = cubit,
        _logger = logger;

  final AuthenticationRepository _repository;
  final AuthenticationCubit _cubit;
  final Logger _logger;

  // Will be set by [initialize].
  late final AccountRemoteDataSource _accountRemoteDataSource;

  final _initializationCompleter = Completer<void>();
  final _throttler = Throttler<Request?>();

  /// Initializes the [RetryAuthenticator] by providing the
  /// [AccountRemoteDataSource] to use.
  ///
  /// This method must be called before the [RetryAuthenticator] is used.
  void initialize(AccountRemoteDataSource accountRemoteDataSource) {
    _initializationCompleter.complete();
    _accountRemoteDataSource = accountRemoteDataSource;
  }

  @override
  Future<Request?> authenticate(
    Request request,
    Response response, [
    Request? _,
  ]) async {
    if (!_initializationCompleter.isCompleted) {
      throw StateError(
        'This RetryAuthenticator is not ready. '
        'Call initialize() before using it.',
      );
    }

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

    return _retryLogin(request)
        .match(
          () => _onRetryFailed(),
          (newAuthInfo) => _onRetrySucceeded(newAuthInfo, request),
        )
        // Flatten; transform the Task<Task<Request?>> into a Task<Request?>.
        .flatMap(identity)
        .withMinimumDuration(const Duration(milliseconds: 250))
        .throttleWith(_throttler)
        .run();
  }

  /// Attempt to retrieve new [AuthenticationInfo] by logging in with the
  /// stored credentials.
  TaskOption<AuthenticationInfo> _retryLogin(Request request) {
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

  /// Handles the side effects of a failed token refresh and returns null.
  Task<Request?> _onRetryFailed() {
    _logger.e('Failed to refresh token. Signing out.');
    _cubit.unauthenticated();
    return _repository.clearAuthenticationInfo().map((_) => null);
  }

  /// Handles the side effects of a successful token refresh and returns the
  /// new [Request] with the updated token.
  Task<Request> _onRetrySucceeded(AuthenticationInfo newInfo, Request req) {
    _logger.d('Successfully refreshed token. Retrying request.');

    return _repository
        .saveAuthenticationInfo(newInfo)
        .map((_) => req.withBearerToken(newInfo.token));
  }
}
