import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/core/network/network_request_executor.dart';
import 'package:coffeecard/features/user/data/models/user_model.dart';
import 'package:coffeecard/features/user/domain/entities/user.dart';
import 'package:coffeecard/generated/api/coffeecard_api.swagger.dart';
import 'package:coffeecard/generated/api/coffeecard_api_v2.swagger.dart'
    hide MessageResponseDto;
import 'package:coffeecard/models/account/authenticated_user.dart';
import 'package:coffeecard/utils/api_uri_constants.dart';
import 'package:fpdart/fpdart.dart';

class AccountRemoteDataSource {
  AccountRemoteDataSource({
    required this.apiV1,
    required this.apiV2,
    required this.executor,
  });

  final CoffeecardApi apiV1;
  final CoffeecardApiV2 apiV2;
  final NetworkRequestExecutor executor;

  Future<Either<NetworkFailure, AuthenticatedUser>> login(
    String email,
    String encodedPasscode,
  ) async {
    return executor.executeAndMap(
      () => apiV1.apiV1AccountLoginPost(
        body: LoginDto(
          email: email,
          password: encodedPasscode,
          version: ApiUriConstants.minAppVersion,
        ),
      ),
      (result) => AuthenticatedUser(
        email: email,
        token: result.token!,
      ),
    );
  }

  Future<Either<NetworkFailure, User>> getUser() async {
    return executor.executeAndMap(
      apiV2.apiV2AccountGet,
      UserModel.fromResponse,
    );
  }

  Future<Either<NetworkFailure, Unit>> requestPasscodeReset(String email) {
    return executor.executeAndMap(
      () => apiV1.apiV1AccountForgotpasswordPost(body: EmailDto(email: email)),
      (_) => unit,
    );
  }

  Future<Either<NetworkFailure, bool>> emailExists(String email) async {
    return executor.executeAndMap(
      () => apiV2.apiV2AccountEmailExistsPost(
        body: EmailExistsRequest(email: email),
      ),
      (result) => result.emailExists,
    );
  }
}
