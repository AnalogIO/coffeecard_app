import 'package:coffeecard/data/repositories/utils/executor.dart';
import 'package:coffeecard/data/repositories/utils/request_types.dart';
import 'package:coffeecard/generated/api/coffeecard_api.swagger.dart';
import 'package:coffeecard/generated/api/coffeecard_api_v2.swagger.dart'
    hide MessageResponseDto;
import 'package:coffeecard/models/account/authenticated_user.dart';
import 'package:coffeecard/models/account/update_user.dart';
import 'package:coffeecard/models/account/user.dart';
import 'package:coffeecard/utils/api_uri_constants.dart';
import 'package:coffeecard/utils/either.dart';

class AccountRepository {
  AccountRepository({
    required this.apiV1,
    required this.apiV2,
    required this.executor,
  });

  final CoffeecardApi apiV1;
  final CoffeecardApiV2 apiV2;
  final Executor executor;

  Future<Either<RequestError, RequestSuccess>> register(
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
      transformer: (_) => RequestSuccess(),
    );
  }

  /// Returns the user token or throws an error.
  Future<Either<RequestError, AuthenticatedUser>> login(
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
      transformer: (dto) => AuthenticatedUser(email: email, token: dto.token!),
    );
  }

  Future<Either<RequestError, User>> getUser() async {
    return executor.execute(
      apiV1.apiV1AccountGet,
      transformer: User.fromDTO,
    );
  }

  /// Update user information
  Future<Either<RequestError, User>> updateUser(UpdateUser user) async {
    final userDTO = UpdateUserDto(
      name: user.name,
      programmeId: user.programmeId,
      email: user.email,
      privacyActivated: user.privacyActivated,
      password: user.encodedPasscode,
    );

    return executor.execute(
      () => apiV1.apiV1AccountPut(body: userDTO),
      transformer: User.fromDTO,
    );
  }

  Future<Either<RequestError, RequestSuccess>> requestPasscodeReset(
    String email,
  ) async {
    return executor.execute(
      () => apiV1.apiV1AccountForgotpasswordPost(body: EmailDto(email: email)),
      transformer: (_) => RequestSuccess(),
    );
  }

  Future<Either<RequestError, RequestSuccess>> requestAccountDeletion() async {
    return executor.execute(
      apiV2.apiV2AccountDelete,
      transformer: (_) => RequestSuccess(),
    );
  }

  Future<Either<RequestError, bool>> emailExists(String email) async {
    return executor.execute(
      () => apiV2.apiV2AccountEmailExistsPost(
        body: EmailExistsRequest(email: email),
      ),
      transformer: (dto) => dto.emailExists,
    );
  }
}
