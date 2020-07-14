
import 'package:coffeecard/model/account/login.dart';
import 'package:coffeecard/model/account/register_user.dart';
import 'package:coffeecard/model/account/user.dart';
import 'package:coffeecard/model/account/email.dart';
import 'package:coffeecard/model/account/user_id.dart';

import 'package:coffeecard/persistence/http/coffee_card_api_client.dart';
import 'package:coffeecard/persistence/repositories/account_repository.dart';
import 'package:coffeecard/persistence/storage/secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import 'package:crypto/crypto.dart';
import 'dart:convert';


class AccountRepositoryImpl implements AccountRepository {
  final CoffeeCardApiClient _restClient;
  final Logger _logger;
  final SecureStorage _storage;

  AccountRepositoryImpl(this._restClient, this._logger, this._storage);

  @override
  Future register(RegisterUser register) async{
    try {
      await _restClient.register(register);
    } on DioError catch (error) {
      final httpResponse = error.response;
      _logger.e("API Error ${httpResponse.statusCode} ${httpResponse.statusMessage}");
      rethrow;
    }
  }

  @override
  Future login(String userName, String password) async {
    var bytes = utf8.encode(password);
    var passwordHash = sha256.convert(bytes);
    var base64Pass = base64Encode(passwordHash.bytes);
    var login = Login(userName, base64Pass, "2.1.0"); //TODO get the version number from somewhere

    try {
      var token = await _restClient.login(login);
      await _storage.saveToken(token.token);
    } on DioError catch (error) {
      final httpResponse = error.response;
      _logger.e("API Error ${httpResponse.statusCode} ${httpResponse.statusMessage}");
      rethrow;
    }
  }

  @override
  Future<User> getUser() async {
    try {
      User user = await _restClient.getUser();
      return user;
    } on DioError catch (error) {
      final httpResponse = error.response;
      _logger.e("API Error ${httpResponse.statusCode} ${httpResponse.statusMessage}");
      rethrow;
    }
  }

  @override
  Future<User> updateUser(User user) async {
    try {
      User updatedUser = await _restClient.updateUser(user);
      return updatedUser;
    } on DioError catch (error) {
      final httpResponse = error.response;
      _logger.e("API Error ${httpResponse.statusCode} ${httpResponse.statusMessage}");
      rethrow;
    }
  }

  @override
  Future<User> getUserById(UserId id) async {
    try {
      User user = await _restClient.getUserById(id);
      return user;
    } on DioError catch (error) {
      final httpResponse = error.response;
      _logger.e("API Error ${httpResponse.statusCode} ${httpResponse.statusMessage}");
      rethrow;
    }
  }

  @override
  Future<void> forgottenPassword(Email email) async {
    try {
      await _restClient.forgottenPassword(email);
    } on DioError catch (error) {
      final httpResponse = error.response;
      _logger.e("API Error ${httpResponse.statusCode} ${httpResponse.statusMessage}");
      rethrow;
    }
  }
}
