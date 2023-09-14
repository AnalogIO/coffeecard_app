import 'package:coffeecard/core/errors/email_not_verified_failure.dart';
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

  Future<Either<Failure, AuthenticatedUser>> login(
    String email,
    String encodedPasscode,
  ) async {
    final result = await executor.execute(
      () => apiV1.apiV1AccountLoginPost(
        body: LoginDto(
          email: email,
          password: encodedPasscode,
          version: ApiUriConstants.minAppVersion,
        ),
      ),
    );

    return result.fold(
      (err) {
        /// API returns 403 when email is not verified
        if (err is ServerFailure && err.statuscode == 403) {
          return const Left(EmailNotVerifiedFailure());
        }

        return Left(err);
      },
      (result) => Right(AuthenticatedUser(email: email, token: result.token!)),
    );
  }

  Future<Either<NetworkFailure, User>> getUser() {
    return executor.execute(apiV2.apiV2AccountGet).map(UserModel.fromResponse);
  }

  Future<Either<NetworkFailure, Unit>> requestPasscodeReset(String email) {
    final body = EmailDto(email: email);
    return executor.executeAndDiscard(
      () => apiV1.apiV1AccountForgotpasswordPost(body: body),
    );
  }

  Future<Either<NetworkFailure, bool>> emailExists(String email) {
    final body = EmailExistsRequest(email: email);
    return executor
        .execute(() => apiV2.apiV2AccountEmailExistsPost(body: body))
        .map((result) => result.emailExists);
  }
}
