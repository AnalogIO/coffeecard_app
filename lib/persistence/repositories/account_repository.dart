import 'dart:convert';

import 'package:coffeecard/model/account/authenticated_user.dart';
import 'package:coffeecard/model/account/email.dart';
import 'package:coffeecard/model/account/login.dart';
import 'package:coffeecard/model/account/register_user.dart';
import 'package:coffeecard/model/account/user.dart';
import 'package:coffeecard/model/account/user_id.dart';
import 'package:coffeecard/persistence/http/coffee_card_api_client.dart';
import 'package:coffeecard/utils/exception_extractor.dart';
import 'package:crypto/crypto.dart' show sha256;
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class UnauthorizedError implements Exception {
  final String message;
  UnauthorizedError(this.message);

  @override
  String toString() => message;
}

class AccountRepository {
  final CoffeeCardApiClient _restClient;
  final Logger _logger;

  AccountRepository(this._restClient, this._logger);

  // TODO Should probably have another return type in order to support
  //      the intended registration flow?
  Future<void> register(RegisterUser register) async {
    try {
      await _restClient.register(register);
    } on DioError catch (error) {
      final resp = error.response;
      _logger.e('API Error ${resp?.statusCode} ${resp?.statusMessage}');
      throw UnauthorizedError(getDIOError(error));
    }
  }

  /// Returns the user token or throws an error.
  Future<AuthenticatedUser> login(String email, String passcode) async {
    final bytes = utf8.encode(passcode);
    final passcodeHash = sha256.convert(bytes);
    final base64Pass = base64Encode(passcodeHash.bytes);
    final login = Login(
      email,
      base64Pass,
      '2.1.0',
    ); //TODO get the version number from somewhere

    try {
      final token = await _restClient.login(login);
      return AuthenticatedUser(
        email: email,
        token: token.token,
      );
    } on DioError catch (error) {
      final resp = error.response;
      _logger.e('API Error ${resp?.statusCode} ${resp?.statusMessage}');
      throw UnauthorizedError(getDIOError(error));
    }
  }

  Future<User> getUser() async {
    try {
      final User user = await _restClient.getUser();
      return user;
    } on DioError catch (error) {
      final resp = error.response;
      _logger.e('API Error ${resp?.statusCode} ${resp?.statusMessage}');
      rethrow;
    }
  }

  Future<User> updateUser(User user) async {
    try {
      final User updatedUser = await _restClient.updateUser(user);
      return updatedUser;
    } on DioError catch (error) {
      final resp = error.response;
      _logger.e('API Error ${resp?.statusCode} ${resp?.statusMessage}');
      rethrow;
    }
  }

  Future<User> getUserById(UserId id) async {
    try {
      final User user = await _restClient.getUserById(id);
      return user;
    } on DioError catch (error) {
      final resp = error.response;
      _logger.e('API Error ${resp?.statusCode} ${resp?.statusMessage}');
      rethrow;
    }
  }

  Future<void> forgottenPassword(Email email) async {
    try {
      await _restClient.forgottenPassword(email);
    } on DioError catch (error) {
      final resp = error.response;
      _logger.e('API Error ${resp?.statusCode} ${resp?.statusMessage}');
      rethrow;
    }
  }
}
