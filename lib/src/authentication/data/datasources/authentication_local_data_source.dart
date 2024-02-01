import 'dart:convert';

import 'package:coffeecard/features/authentication.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fpdart/fpdart.dart';
import 'package:logger/logger.dart';

class AuthenticationLocalDataSource {
  static const _authenticatedUserKey = 'authenticated_user';

  final FlutterSecureStorage storage;
  final Logger logger;

  const AuthenticationLocalDataSource({
    required this.storage,
    required this.logger,
  });

  Future<void> saveAuthenticatedUser(
    AuthenticatedUserModel authenticatedUser,
  ) async {
    await storage.write(
      key: _authenticatedUserKey,
      value: json.encode(authenticatedUser),
    );

    logger.d('$authenticatedUser added to storage');
  }

  Future<Option<AuthenticatedUserModel>> getAuthenticatedUser() async {
    final jsonString = await storage.read(key: _authenticatedUserKey);

    if (jsonString == null) {
      return const None();
    }

    final user = AuthenticatedUserModel.fromJson(
      json.decode(jsonString) as Map<String, dynamic>,
    );

    return Some(user);
  }

  Future<void> clearAuthenticatedUser() async {
    await storage.delete(key: _authenticatedUserKey);
    logger.d('deleted data for $_authenticatedUserKey');
  }

  Future<void> updateToken(String token) async {
    final user = await getAuthenticatedUser();

    user.map(
      (user) async {
        final model = AuthenticatedUserModel(
          email: user.email,
          token: token,
          encodedPasscode: user.encodedPasscode,
        );

        await saveAuthenticatedUser(model);
      },
    );
  }
}
