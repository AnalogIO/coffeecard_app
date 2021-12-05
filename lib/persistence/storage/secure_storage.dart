import 'package:coffeecard/persistence/repositories/account_repository.dart'
    show UserAuth;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';

class SecureStorage {
  static const _emailKey = 'email';
  static const _tokenKey = 'authentication_token';

  final FlutterSecureStorage _storage;
  final Logger _logger;

  SecureStorage(this._logger) : _storage = const FlutterSecureStorage();

  Future<bool> get hasToken async => await readToken() != null;

  Future<void> saveUserAuth(String email, String token) async {
    await _storage.write(key: _emailKey, value: email);
    await _storage.write(key: _tokenKey, value: token);
    _logger.d('Email ($email) and token added to Secure Storage');
  }

  Future<UserAuth?> getUserAuth() async {
    final email = await _storage.read(key: _emailKey);
    final token = await _storage.read(key: _tokenKey);
    return email != null && token != null
        ? UserAuth(email: email, token: token)
        : null;
  }

  Future<void> clearUserAuth() async {
    if (await getUserAuth() == null) return;
    await _storage.delete(key: _emailKey);
    await _storage.delete(key: _tokenKey);
    _logger.d('Email and token removed from Secure Storage');
  }

  Future<String?> readEmail() async {
    return _storage.read(key: _emailKey);
  }

  Future<String?> readToken() async {
    return _storage.read(key: _tokenKey);
  }
}
