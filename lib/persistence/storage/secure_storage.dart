import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';

class SecureStorage {
  static const _userTokenKey = "authentication_token";

  final FlutterSecureStorage _storage;
  final Logger _logger;

  SecureStorage(this._storage, this._logger);

  /// save token to secure storage
  Future<void> saveToken(String token) async {
    await _storage.write(key: _userTokenKey, value: token);
    _logger.d("Token added to Secure Storage");
  }

  /// read token from secure storage, might be nullable
  Future<String> readToken() async {
    return _storage.read(key: _userTokenKey);
  }
}
