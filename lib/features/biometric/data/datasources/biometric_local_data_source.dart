import 'dart:convert';

import 'package:coffeecard/features/biometric/data/models/user_credentials.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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
}
