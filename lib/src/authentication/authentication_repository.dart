import 'dart:convert';

import 'package:coffeecard/core/store/store.dart';
import 'package:coffeecard/features/authentication.dart';
import 'package:fpdart/fpdart.dart';
import 'package:logger/logger.dart';

const _authenticationInfoKey = 'authenticationInfo';

// FIXME: Store classes instead of JSON strings
//  (Perhaps using Isar instead of Hive?
//  Hive's latest version is not production ready yet.)
class AuthenticationRepository {
  const AuthenticationRepository({
    required this.crate,
    required this.logger,
  });

  /// The encrypted [Crate] used to store the
  /// [AuthenticationInfo] (as a JSON string).
  final Crate<String> crate;
  final Logger logger;

  Task<Unit> saveAuthenticationInfo(AuthenticationInfo info) {
    return crate
        .put(_authenticationInfoKey, json.encode(info.toJson()))
        .andThen(() => _logMessage('Authentication info saved.'));
  }

  TaskOption<AuthenticationInfo> getAuthenticationInfo() {
    return crate
        .get(_authenticationInfoKey)
        .map((jsonString) => json.decode(jsonString) as Map<String, dynamic>)
        .map(AuthenticationInfo.fromJson);
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
