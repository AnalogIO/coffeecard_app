import 'package:coffeecard/core/store/store.dart';
import 'package:coffeecard/features/authentication.dart';
import 'package:fpdart/fpdart.dart';
import 'package:logger/logger.dart';

const _authenticationInfoKey = 'authenticationInfo';

class AuthenticationRepository {
  const AuthenticationRepository({
    required this.crate,
    required this.logger,
  });

  /// The encrypted [Crate] used to store the [AuthenticationInfo].
  final Crate<AuthenticationInfo> crate;
  final Logger logger;

  Task<Unit> saveAuthenticationInfo(AuthenticationInfo info) {
    return crate
        .put(_authenticationInfoKey, info)
        .andThen(() => _logMessage('Authentication info saved.'));
  }

  TaskOption<AuthenticationInfo> getAuthenticationInfo() {
    return crate.get(_authenticationInfoKey);
  }

  TaskOption<String> getAuthenticationToken() {
    return getAuthenticationInfo().map((info) => info.token);
  }

  Task<Unit> clearAuthenticationInfo() {
    return crate
        .clear()
        .andThen(() => _logMessage('Authentication info cleared.'));
  }

  Task<Unit> _logMessage(String message) => Task(() async {
        logger.d(message);
        return unit;
      });
}
