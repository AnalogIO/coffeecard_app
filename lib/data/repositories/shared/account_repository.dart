import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/core/network/network_request_executor.dart';
import 'package:coffeecard/features/user/data/models/user_model.dart';
import 'package:coffeecard/features/user/domain/entities/user.dart';
import 'package:coffeecard/generated/api/coffeecard_api.swagger.dart';
import 'package:coffeecard/generated/api/coffeecard_api_v2.swagger.dart'
    hide MessageResponseDto;
import 'package:coffeecard/models/account/authenticated_user.dart';
import 'package:coffeecard/models/account/update_user.dart';
import 'package:coffeecard/utils/api_uri_constants.dart';
import 'package:fpdart/fpdart.dart';

class AccountRepository {
  AccountRepository({
    required this.apiV1,
    required this.apiV2,
    required this.executor,
  });

  final CoffeecardApi apiV1;
  final CoffeecardApiV2 apiV2;
  final NetworkRequestExecutor executor;

  Future<Either<NetworkFailure, void>> register(
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

    return result.map((_) => const Right(null));
  }

  /// Returns the user token or throws an error.
  Future<Either<NetworkFailure, AuthenticatedUser>> login(
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

  Future<Either<NetworkFailure, User>> getUser() async {
    final result = await executor(
      apiV2.apiV2AccountGet,
    );

    return result.map(UserModel.fromResponse);
  }

  /// Update user information
  Future<Either<NetworkFailure, User>> updateUser(UpdateUser user) async {
    final result = await executor(
      () => apiV2.apiV2AccountPut(
        body: UpdateUserRequest(
          name: user.name,
          programmeId: user.occupationId,
          email: user.email,
          privacyActivated: user.privacyActivated,
          password: user.encodedPasscode,
        ),
      ),
    );

    return result.map(UserModel.fromResponse);
  }

  Future<Either<NetworkFailure, void>> requestPasscodeReset(
    String email,
  ) async {
    final result = await executor(
      () => apiV1.apiV1AccountForgotpasswordPost(body: EmailDto(email: email)),
    );

    return result.bind((_) => const Right(null));
  }

  Future<Either<NetworkFailure, void>> requestAccountDeletion() async {
    final result = await executor(
      apiV2.apiV2AccountDelete,
    );

    return result.bind((_) => const Right(null));
  }

  Future<Either<NetworkFailure, bool>> emailExists(String email) async {
    final result = await executor(
      () => apiV2.apiV2AccountEmailExistsPost(
        body: EmailExistsRequest(email: email),
      ),
    );

    return result.map((result) => result.emailExists);
  }
}
