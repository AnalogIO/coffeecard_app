import 'package:coffeecard/core/errors/exceptions.dart';
import 'package:coffeecard/data/repositories/utils/executor.dart';
import 'package:coffeecard/data/repositories/utils/request_types.dart';
import 'package:coffeecard/features/user/data/models/user_model.dart';
import 'package:coffeecard/generated/api/coffeecard_api.swagger.dart';
import 'package:coffeecard/generated/api/coffeecard_api_v2.swagger.dart'
    hide MessageResponseDto;
import 'package:coffeecard/models/account/authenticated_user.dart';
import 'package:coffeecard/models/account/update_user.dart';
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
    int occupationId,
  ) async {
    return executor.execute(
      () => apiV2.apiV2AccountPost(
        body: RegisterAccountRequest(
          name: name,
          email: email,
          password: encodedPasscode,
          programmeId: occupationId,
        ),
      ),
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

  Future<UserModel> getUser() async {
    final response = await apiV2.apiV2AccountGet();

    if (!response.isSuccessful) {
      throw ServerException.fromResponse(response);
    }

    return UserModel.fromResponse(response.body!);
  }

  /// Update user information
  Future<UserModel> updateUser(UpdateUser user) async {
    final response = await apiV2.apiV2AccountPut(
      body: UpdateUserRequest(
        name: user.name,
        programmeId: user.occupationId,
        email: user.email,
        privacyActivated: user.privacyActivated,
        password: user.encodedPasscode,
      ),
    );

    if (!response.isSuccessful) {
      throw ServerException.fromResponse(response);
    }

    return UserModel.fromResponse(response.body!);
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
