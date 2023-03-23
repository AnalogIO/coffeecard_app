import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/core/network/executor.dart';
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

  Future<Either<ServerFailure, void>> register(
    String name,
    String email,
    String encodedPasscode,
    int occupationId,
  ) async {
    final result = await executor(
      () => apiV2.apiV2AccountPost(
        body: RegisterAccountRequest(
          name: name,
          email: email,
          password: encodedPasscode,
          programmeId: occupationId,
        ),
      ),
    );

    return result.bind((_) => const Right(null));
  }

  /// Returns the user token or throws an error.
  Future<Either<ServerFailure, AuthenticatedUser>> login(
    String email,
    String encodedPasscode,
  ) async {
    final result = await executor(
      () => apiV1.apiV1AccountLoginPost(
        body: LoginDto(
          email: email,
          password: encodedPasscode,
          version: ApiUriConstants.minAppVersion,
        ),
      ),
    );

    return result.map(
      (result) => AuthenticatedUser(
        email: email,
        token: result.token!,
      ),
    );
  }

  Future<Either<ServerFailure, User>> getUser() async {
    final result = await executor(
      apiV1.apiV1AccountGet,
    );

    return result.map((result) => User.fromDTO(result));
  }

  /// Update user information
  Future<Either<ServerFailure, User>> updateUser(UpdateUser user) async {
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

    return result.map(User.fromDTO);
  }

  Future<Either<ServerFailure, void>> requestPasscodeReset(
    String email,
  ) async {
    final result = await executor(
      () => apiV1.apiV1AccountForgotpasswordPost(body: EmailDto(email: email)),
    );

    return result.bind((_) => const Right(null));
  }

  Future<Either<ServerFailure, void>> requestAccountDeletion() async {
    final result = await executor(
      apiV2.apiV2AccountDelete,
    );

    return result.bind((_) => const Right(null));
  }

  Future<Either<ServerFailure, bool>> emailExists(String email) async {
    final result = await executor(
      () => apiV2.apiV2AccountEmailExistsPost(
        body: EmailExistsRequest(email: email),
      ),
    );

    return result.map((result) => result.emailExists);
  }
}
