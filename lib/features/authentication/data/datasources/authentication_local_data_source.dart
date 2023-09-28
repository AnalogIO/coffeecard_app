import 'package:coffeecard/features/authentication/domain/entities/authenticated_user.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';

class AuthenticationLocalDataSource {
  static const _emailKey = 'email';
  static const _tokenKey = 'authentication_token';
  static const _encodedPasscodeKey = 'encoded_passcode';

  final FlutterSecureStorage storage;
  final Logger logger;

  const AuthenticationLocalDataSource({
    required this.storage,
    required this.logger,
  });

  Future<void> saveAuthenticatedUser(
    String email,
    String encodedPasscode,
    String token,
  ) async {
    await storage.write(key: _emailKey, value: email);
    await storage.write(key: _encodedPasscodeKey, value: encodedPasscode);
    await storage.write(key: _tokenKey, value: token);
    logger.d(
      'Email ($email), encoded passcode and token added to Secure Storage',
    );
  }

  Future<AuthenticatedUser?> getAuthenticatedUser() async {
    final email = await readEmail();
    final token = await readToken();

    return email != null && token != null
        ? AuthenticatedUser(email: email, token: token)
        : null;
  }

  Future<void> clearAuthenticatedUser() async {
    if (await getAuthenticatedUser() == null) return;
    await storage.delete(key: _emailKey);
    await storage.delete(key: _encodedPasscodeKey);
    await storage.delete(key: _tokenKey);
    logger.d('Email, encoded passcode and token removed from Secure Storage');
  }

  Future<void> updateToken(String token) async {
    await storage.write(key: _tokenKey, value: token);
    logger.d('Token updated in Secure Storage');
  }

  Future<String?> readEmail() async {
    return storage.read(key: _emailKey);
  }

  Future<String?> readEncodedPasscode() async {
    return storage.read(key: _encodedPasscodeKey);
  }

  Future<String?> readToken() async {
    return storage.read(key: _tokenKey);
  }
}
