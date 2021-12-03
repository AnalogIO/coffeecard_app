import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';

class SecureStorage {
  static const _emailKey = 'email';
  static const _tokenKey = 'authentication_token';

  final FlutterSecureStorage _storage;
  final Logger _logger;

  SecureStorage(this._logger) : _storage = const FlutterSecureStorage();

  Future<void> saveEmailAndToken(String email, String token) async {
    await _storage.write(key: _emailKey, value: email);
    await _storage.write(key: _tokenKey, value: token);
    _logger.d('Email ($email) and token added to Secure Storage');
  }

  Future<String?> readEmail() async {
    return _storage.read(key: _emailKey);
  }

  Future<String?> readToken() async {
    return _storage.read(key: _tokenKey);
  }
}
