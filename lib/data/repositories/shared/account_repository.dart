import 'dart:convert';

import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/data/api/coffee_card_api_constants.dart';
import 'package:coffeecard/generated/api/coffeecard_api.swagger.swagger.dart';
import 'package:coffeecard/generated/api/coffeecard_api_v2.swagger.swagger.dart';
import 'package:coffeecard/models/account/authenticated_user.dart';
import 'package:coffeecard/models/account/update_user.dart';
import 'package:coffeecard/models/account/user.dart';
import 'package:coffeecard/models/api/api_error.dart';
import 'package:coffeecard/models/api/unauthorized_error.dart';
import 'package:coffeecard/utils/either.dart';
import 'package:crypto/crypto.dart' show sha256;
import 'package:logger/logger.dart';

class AccountRepository {
  final CoffeecardApi _apiV1;
  final CoffeecardApiV2 _apiV2;
  final Logger _logger;

  AccountRepository(this._apiV1, this._apiV2, this._logger);

  String _encodePasscode(String passcode) {
    final bytes = utf8.encode(passcode);
    final passcodeHash = sha256.convert(bytes);
    return base64Encode(passcodeHash.bytes);
  }

  // TODO Should probably have another return type in order to support
  //      the intended registration flow?
  Future<Either<UnauthorizedError, void>> register(
    String name,
    String email,
    String passcode,
  ) async {
    final dto = RegisterDto(
      name: name,
      email: email,
      password: _encodePasscode(passcode),
    );

    final response = await _apiV1.apiV1AccountRegisterPost(body: dto);

    if (response.isSuccessful) {
      return const Right(null);
    } else {
      _logger.e(Strings.formatApiError(response));
      return Left(UnauthorizedError(response.error.toString()));
    }
  }

  Future<Either<ApiError, bool>> emailExists(String email) async {
    // TODO implement emailExists
    throw UnimplementedError();
  }

  /// Returns the user token or throws an error.
  Future<Either<UnauthorizedError, AuthenticatedUser>> login(
    String email,
    String passcode,
  ) async {
    final response = await _apiV1.apiV1AccountLoginPost(
      body: LoginDto(
        email: email,
        password: _encodePasscode(passcode),
        version: CoffeeCardApiConstants.minAppVersion,
      ),
    );

    if (response.isSuccessful) {
      return Right(
        AuthenticatedUser(email: email, token: response.body!.token!),
      );
    } else {
      _logger.e(Strings.formatApiError(response));
      return Left(UnauthorizedError(response.error.toString()));
    }
  }

  Future<Either<ApiError, User>> getUser() async {
    final response = await _apiV1.apiV1AccountGet();

    if (response.isSuccessful) {
      final user = User.fromDTO(response.body!);
      return Right(user);
    } else {
      _logger.e(Strings.formatApiError(response));
      return Left(ApiError(response.error.toString()));
    }
  }

  /// Update user information
  Future<Either<ApiError, User>> updateUser(UpdateUser user) async {
    final userDTO = UpdateUserDto(
      name: user.name,
      programmeId: user.programmeId,
      email: user.email,
      privacyActivated: user.privacyActivated,
      password: user.password != null ? _encodePasscode(user.password!) : null,
    );
    final response = await _apiV1.apiV1AccountPut(body: userDTO);

    if (response.isSuccessful) {
      final user = User.fromDTO(response.body!);
      return Right(user);
    } else {
      _logger.e(Strings.formatApiError(response));
      return Left(ApiError(response.error.toString()));
    }
  }

  Future<Either<ApiError, void>> requestPasswordReset(String email) async {
    final response = await _apiV1.apiV1AccountForgotpasswordPost(
      body: EmailDto(email: email),
    );
    if (response.isSuccessful) {
      return const Right(null);
    } else {
      _logger.e(Strings.formatApiError(response));
      return Left(ApiError(response.error.toString()));
    }
  }

  Future<Either<ApiError, void>> requestAccountDeletion() async {
    final response = await _apiV2.apiV2AccountDelete();
    if (response.isSuccessful) {
      return const Right(null);
    } else {
      _logger.e(Strings.formatApiError(response));
      return Left(ApiError(response.error.toString()));
    }
  }
}
