import 'package:coffeecard/data/repositories/utils/executor.dart';
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

  Future<Either<RequestFailure, RequestSuccess>> register(
    String name,
    String email,
    String encodedPasscode,
  ) async {
    final dto = RegisterDto(
      name: name,
      email: email,
      password: encodedPasscode,
    );

    return executor.execute(
      () => apiV1.apiV1AccountRegisterPost(body: dto),
      (_) => RequestSuccess(),
    );
  }

  /// Returns the user token or throws an error.
  Future<Either<RequestFailure, AuthenticatedUser>> login(
    String email,
    String encodedPasscode,
  ) async {
    return executor.execute(
      () => apiV1.apiV1AccountLoginPost(
        body: LoginDto(
          email: email,
          password: encodedPasscode,
          version: ApiUriConstants.minAppVersion,
        ),
      ),
      (dto) => AuthenticatedUser(email: email, token: dto.token!),
    );
  }

  Future<Either<RequestFailure, User>> getUser() async {
    return executor.execute(
      apiV1.apiV1AccountGet,
      User.fromDTO,
    );
  }

  /// Update user information
  Future<Either<RequestFailure, User>> updateUser(UpdateUser user) async {
    final userDTO = UpdateUserDto(
      name: user.name,
      programmeId: user.programmeId,
      email: user.email,
      privacyActivated: user.privacyActivated,
      password: user.encodedPasscode,
    );

    return executor.execute(
      () => apiV1.apiV1AccountPut(body: userDTO),
      User.fromDTO,
    );
  }

  Future<Either<RequestFailure, RequestSuccess>> requestPasscodeReset(
    String email,
  ) async {
    return executor.execute(
      () => apiV1.apiV1AccountForgotpasswordPost(body: EmailDto(email: email)),
      (_) => RequestSuccess(),
    );
  }

  Future<Either<RequestFailure, RequestSuccess>>
      requestAccountDeletion() async {
    return executor.execute(
      apiV2.apiV2AccountDelete,
      (_) => RequestSuccess(),
    );
  }

  Future<Either<RequestFailure, bool>> emailExists(String email) async {
    return executor.execute(
      () => apiV2.apiV2AccountEmailExistsPost(
        body: EmailExistsRequest(email: email),
      ),
      (dto) => dto.emailExists,
    );
  }
}
