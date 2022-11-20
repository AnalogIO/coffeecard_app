import 'package:coffeecard/models/account/authenticated_user.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';

class SecureStorage {
  static const _emailKey = 'email';
  static const _tokenKey = 'authentication_token';
  static const _encodedPasscodeKey = 'encoded_passcode';

  final FlutterSecureStorage _storage;
  final Logger _logger;

  SecureStorage(this._logger) : _storage = const FlutterSecureStorage();

  Future<bool> get hasToken async => await readToken() != null;

  Future<void> saveAuthenticatedUser(
    String email,
    String encodedPasscode,
    String token,
  ) async {
    await _storage.write(key: _emailKey, value: email);
    await _storage.write(key: _encodedPasscodeKey, value: encodedPasscode);
    await _storage.write(key: _tokenKey, value: token);
    _logger.d(
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
    await _storage.delete(key: _emailKey);
    await _storage.delete(key: _encodedPasscodeKey);
    await _storage.delete(key: _tokenKey);
    _logger.d('Email, encoded passcode and token removed from Secure Storage');
  }

  Future<void> updateToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
    _logger.d('Token updated in Secure Storage');
  }

  Future<String?> readEmail() async {
    return _storage.read(key: _emailKey);
  }

  Future<String?> readEncodedPasscode() async {
    return _storage.read(key: _encodedPasscodeKey);
  }

  Future<String?> readToken() async {
    return _storage.read(key: _tokenKey);
  }
}
