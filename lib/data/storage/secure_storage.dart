import 'package:coffeecard/models/account/authenticated_user.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';

class SecureStorage {
  static const _emailKey = 'email';
  static const _tokenKey = 'authentication_token';
  static const _passcodeKey = 'password';

  final FlutterSecureStorage _storage;
  final Logger _logger;

  SecureStorage(this._logger) : _storage = const FlutterSecureStorage();

  Future<bool> get hasToken async => await readToken() != null;

  Future<void> saveAuthenticatedUser(
      String email, String passcode, String token) async {
    await _storage.write(key: _emailKey, value: email);
    await _storage.write(key: _passcodeKey, value: passcode);
    await _storage.write(key: _tokenKey, value: token);
    _logger.d('Email ($email), passcode and token added to Secure Storage');
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
    await _storage.delete(key: _passcodeKey);
    await _storage.delete(key: _tokenKey);
    _logger.d('Email, passcode and token removed from Secure Storage');
  }

  Future<String?> readEmail() async {
    return _storage.read(key: _emailKey);
  }

  Future<String?> readPasscode() async {
    return _storage.read(key: _passcodeKey);
  }

  Future<String?> readToken() async {
    return _storage.read(key: _tokenKey);
  }
}
