import 'dart:convert';

import 'package:coffeecard/data/api/coffee_card_api_constants.dart';
import 'package:coffeecard/generated/api/coffeecard_api.swagger.swagger.dart';
import 'package:coffeecard/models/account/authenticated_user.dart';
import 'package:coffeecard/models/account/unauthorized_error.dart';
import 'package:coffeecard/models/api/api_error.dart';
import 'package:crypto/crypto.dart' show sha256;
import 'package:logger/logger.dart';

class AccountRepository {
  final CoffeecardApi _api;
  final Logger _logger;

  AccountRepository(this._api, this._logger);

  // TODO Should probably have another return type in order to support
  //      the intended registration flow?
  Future<void> register(RegisterDto registerDto) async {
    final response = await _api.apiVVersionAccountRegisterPost(
      body: registerDto,
      version: CoffeeCardApiConstants.apiVersion,
    );
    if (!response.isSuccessful) {
      _logger.e('API Error ${response.statusCode} ${response.error}');
      throw UnauthorizedError(response.error.toString());
    }
  }

  /// Returns the user token or throws an error.
  Future<AuthenticatedUser> login(String email, String passcode) async {
    final bytes = utf8.encode(passcode);
    final passcodeHash = sha256.convert(bytes);
    final base64Pass = base64Encode(passcodeHash.bytes);

    final response = await _api.apiVVersionAccountLoginPost(
      body: LoginDto(
        email: email,
        password: base64Pass,
        version: CoffeeCardApiConstants.minAppVersion,
      ),
      version: CoffeeCardApiConstants.apiVersion,
    );

    if (response.isSuccessful) {
      return AuthenticatedUser(email: email, token: response.body!.token!);
    } else {
      _logger.e('API Error ${response.statusCode} ${response.error}');
      throw UnauthorizedError(response.error.toString());
    }
  }

  /// Get user information
  Future<UserDto> getUser() async {
    final response = await _api.apiVVersionAccountGet(
      version: CoffeeCardApiConstants.apiVersion,
    );

    if (response.isSuccessful) {
      return response.body!;
    } else {
      _logger.e('API Error ${response.statusCode} ${response.error}');
      throw ApiError(response.error.toString());
    }
  }

  /// Update user information
  Future<UserDto> updateUser(UpdateUserDto user) async {
    final response = await _api.apiVVersionAccountPut(
      version: CoffeeCardApiConstants.apiVersion,
      body: user,
    );

    if (response.isSuccessful) {
      return response.body!;
    } else {
      _logger.e('API Error ${response.statusCode} ${response.error}');
      throw ApiError(response.error.toString());
    }
  }

  /// Request user password reset
  Future<void> forgotPassword(EmailDto email) async {
    final response = await _api.apiVVersionAccountForgotpasswordPost(
      body: email,
      version: CoffeeCardApiConstants.apiVersion,
    );

    if (!response.isSuccessful) {
      _logger.e('API Error ${response.statusCode} ${response.error}');
      throw ApiError(response.error.toString());
    }
  }
}
