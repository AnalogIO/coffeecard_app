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

  final Box<AuthenticationInfo> store;
  final Logger logger;

  /// Store the authentication info in an encrypted Hive box.
  Task<Unit> saveAuthenticationInfo(AuthenticationInfo info) {
    return Task(() => store.put(_authenticationInfoKey, info))
        .map((_) => logger.d('Authentication info saved'))
        .map((_) => unit);
  }

  TaskOption<AuthenticationInfo> getAuthenticationInfo() {
    return TaskOption.fromNullable(store.get(_authenticationInfoKey));
  }

  Task<Unit> clearAuthenticationInfo() {
    return Task(() async {
      await store.clear();
      logger.d('Authentication info cleared');
      return unit;
    });
  }
}
