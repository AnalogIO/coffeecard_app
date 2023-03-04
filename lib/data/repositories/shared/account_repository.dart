import 'package:coffeecard/core/errors/exceptions.dart';
import 'package:coffeecard/core/network/executor.dart';
import 'package:coffeecard/data/repositories/utils/request_types.dart';
import 'package:coffeecard/generated/api/coffeecard_api.swagger.dart';
import 'package:coffeecard/generated/api/coffeecard_api_v2.swagger.dart'
    hide MessageResponseDto;
import 'package:coffeecard/models/account/authenticated_user.dart';
import 'package:coffeecard/models/account/update_user.dart';
import 'package:coffeecard/models/account/user.dart';
import 'package:coffeecard/utils/api_uri_constants.dart';
import 'package:dartz/dartz.dart';

class AccountRepository {
  AccountRepository({
    required this.apiV1,
    required this.apiV2,
    required this.executor,
  });

  final CoffeecardApi apiV1;
  final CoffeecardApiV2 apiV2;
  final Executor executor;

  Future<Either<RequestFailure, void>> register(
    String name,
    String email,
    String encodedPasscode,
    int occupationId,
  ) async {
    try {
      await executor(
        () => apiV2.apiV2AccountPost(
          body: RegisterAccountRequest(
            name: name,
            email: email,
            password: encodedPasscode,
            programmeId: occupationId,
          ),
        ),
      );

      return const Right(null);
    } on ServerException catch (e) {
      return Left(RequestFailure(e.error));
    }
  }

  /// Returns the user token or throws an error.
  Future<Either<RequestFailure, AuthenticatedUser>> login(
    String email,
    String encodedPasscode,
  ) async {
    try {
      final result = await executor(
        () => apiV1.apiV1AccountLoginPost(
          body: LoginDto(
            email: email,
            password: encodedPasscode,
            version: ApiUriConstants.minAppVersion,
          ),
        ),
      );

      return Right(AuthenticatedUser(email: email, token: result!.token!));
    } on ServerException catch (e) {
      return Left(RequestFailure(e.error));
    }
  }

  Future<Either<RequestFailure, User>> getUser() async {
    try {
      final result = await executor(
        apiV1.apiV1AccountGet,
      );

      return Right(User.fromDTO(result!));
    } on ServerException catch (e) {
      return Left(RequestFailure(e.error));
    }
  }

  /// Update user information
  Future<Either<RequestFailure, User>> updateUser(UpdateUser user) async {
    try {
      final result = await executor(
        () => apiV1.apiV1AccountPut(
          body: UpdateUserDto(
            name: user.name,
            programmeId: user.occupationId,
            email: user.email,
            privacyActivated: user.privacyActivated,
            password: user.encodedPasscode,
          ),
        ),
      );

      return Right(User.fromDTO(result!));
    } on ServerException catch (e) {
      return Left(RequestFailure(e.error));
    }
  }

  Future<Either<RequestFailure, void>> requestPasscodeReset(
    String email,
  ) async {
    try {
      executor(
        () =>
            apiV1.apiV1AccountForgotpasswordPost(body: EmailDto(email: email)),
      );

      return const Right(null);
    } on ServerException catch (e) {
      return Left(RequestFailure(e.error));
    }
  }

  Future<Either<RequestFailure, void>> requestAccountDeletion() async {
    try {
      executor(
        apiV2.apiV2AccountDelete,
      );

      return const Right(null);
    } on ServerException catch (e) {
      return Left(RequestFailure(e.error));
    }
  }

  Future<Either<RequestFailure, bool>> emailExists(String email) async {
    try {
      final result = await executor(
        () => apiV2.apiV2AccountEmailExistsPost(
          body: EmailExistsRequest(email: email),
        ),
      );

      return Right(result!.emailExists);
    } on ServerException catch (e) {
      return Left(RequestFailure(e.error));
    }
  }
}
