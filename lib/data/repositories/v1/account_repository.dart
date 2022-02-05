import 'dart:convert';

import 'package:coffeecard/data/api/coffee_card_api_constants.dart';
import 'package:coffeecard/generated/api/coffeecard_api.swagger.swagger.dart';
import 'package:coffeecard/models/account/authenticated_user.dart';
import 'package:coffeecard/models/api/api_error.dart';
import 'package:coffeecard/models/api/unauthorized_error.dart';
import 'package:coffeecard/utils/either.dart';
import 'package:crypto/crypto.dart' show sha256;
import 'package:logger/logger.dart';

class AccountRepository {
  final CoffeecardApi _api;
  final Logger _logger;

  AccountRepository(this._api, this._logger);

  String _encodePasscode(String passcode) {
    final bytes = utf8.encode(passcode);
    final passcodeHash = sha256.convert(bytes);
    return base64Encode(passcodeHash.bytes);
  }

  // TODO Should probably have another return type in order to support
  //      the intended registration flow?
  Future<void> register(RegisterDto registerDto) async {
    final dto =
        registerDto.copyWith(password: _encodePasscode(registerDto.password!));

    final response = await _api.apiV1AccountRegisterPost(body: dto);

    if (!response.isSuccessful) {
      _logger.e('API Error ${response.statusCode} ${response.error}');
      throw UnauthorizedError(response.error.toString());
    }
  }

  Future<bool> emailExists(String email) async {
    // TODO implement emailExists
    return false;
  }

  /// Returns the user token or throws an error.
  Future<Either<UnauthorizedError, AuthenticatedUser>> login(String email, String passcode) async {
    final response = await _api.apiV1AccountLoginPost(
      body: LoginDto(
        email: email,
        password: _encodePasscode(passcode),
        version: CoffeeCardApiConstants.minAppVersion,
      ),
    );

    if (response.isSuccessful) {
      return Right(AuthenticatedUser(email: email, token: response.body!.token!));
    } else {
      _logger.e('API Error ${response.statusCode} ${response.error}');
      return Left(UnauthorizedError(response.error.toString()));
    }
  }

  /// Get user information
  Future<UserDto> getUser() async {
    final response = await _api.apiV1AccountGet();

    if (response.isSuccessful) {
      return response.body!;
    } else {
      _logger.e('API Error ${response.statusCode} ${response.error}');
      throw ApiError(response.error.toString());
    }
  }

  /// Update user information
  Future<Either<ApiError,UserDto>> updateUser(UpdateUserDto user) async {
    final response = await _api.apiV1AccountPut(
      body: user,
    );

    if (response.isSuccessful) {
      return Right(response.body!);
    } else {
      _logger.e('API Error ${response.statusCode} ${response.error}');
      return Left(ApiError(response.error.toString()));
    }
  }

  /// Request user password reset
  Future<void> forgotPassword(EmailDto email) async {
    final response = await _api.apiV1AccountForgotpasswordPost(
      body: email,
    );

    if (!response.isSuccessful) {
      _logger.e('API Error ${response.statusCode} ${response.error}');
      throw ApiError(response.error.toString());
    }
  }
}
