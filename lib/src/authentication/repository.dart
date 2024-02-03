import 'package:coffeecard/core/store_utils.dart';
import 'package:coffeecard/features/authentication.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';

const _authenticationInfoKey = 'authenticationInfo';

class AuthenticationRepository {
  const AuthenticationRepository({
    required this.store,
    required this.logger,
  });

  /// The [Box] used to store the [AuthenticationInfo].
  ///
  /// Should be encrypted using [HiveFP.openEncryptedBox].
  final Box<AuthenticationInfo> store;
  final Logger logger;

  Task<Unit> saveAuthenticationInfo(AuthenticationInfo info) {
    return store
        .putAsTask(_authenticationInfoKey, info)
        .andThen(() => _logMessage('Authentication info saved.'));
  }

  TaskOption<AuthenticationInfo> getAuthenticationInfo() {
    return store.getAsTaskOption(_authenticationInfoKey);
  }

  Task<Unit> clearAuthenticationInfo() {
    return store
        .clearAsTask()
        .andThen(() => _logMessage('Authentication info cleared.'));
  }

  Task<Unit> _logMessage(String message) => Task(() async {
        logger.d(message);
        return unit;
      });
}
