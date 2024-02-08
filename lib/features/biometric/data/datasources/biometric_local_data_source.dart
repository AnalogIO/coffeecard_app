import 'dart:convert';

import 'package:coffeecard/features/biometric/data/models/user_credentials.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fpdart/fpdart.dart';
import 'package:logger/logger.dart';

class BiometricLocalDataSource {
  static const _biometricKey = 'biometric';

  final FlutterSecureStorage storage;
  final Logger logger;

  const BiometricLocalDataSource({
    required this.storage,
    required this.logger,
  });

  Future<void> saveCredentials(String email, String encodedPasscode) async {
    final credentials = UserCredentials(
      email: email,
      encodedPasscode: encodedPasscode,
    );

    await storage.write(
      key: _biometricKey,
      value: json.encode(credentials),
    );
  }

  Future<Option<UserCredentials>> read() async {
    final jsonString =
        Option.fromNullable(await storage.read(key: _biometricKey));

    return jsonString.map(
      (t) => UserCredentials.fromJson(json.decode(t) as Map<String, dynamic>),
    );
  }

  Future<void> clearBiometrics() async {
    await storage.delete(key: _biometricKey);
  }
}
