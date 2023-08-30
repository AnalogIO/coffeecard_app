import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/core/network/network_request_executor.dart';
import 'package:coffeecard/features/user/data/models/user_model.dart';
import 'package:coffeecard/generated/api/coffeecard_api_v2.swagger.dart';
import 'package:coffeecard/models/account/update_user.dart';
import 'package:fpdart/fpdart.dart';

class UserRemoteDataSource {
  final CoffeecardApiV2 apiV2;
  final NetworkRequestExecutor executor;

  UserRemoteDataSource({
    required this.apiV2,
    required this.executor,
  });

  /// Get the currently logged in user.
  Future<Either<NetworkFailure, UserModel>> getUser() {
    return executor.executeAndMap(
      apiV2.apiV2AccountGet,
      UserModel.fromResponse,
    );
  }

  /// Updates the details of the currently logged in user based on
  /// the non-null details in [user]
  Future<Either<NetworkFailure, UserModel>> updateUserDetails(UpdateUser user) {
    return executor.executeAndMap(
      () => apiV2.apiV2AccountPut(
        body: UpdateUserRequest(
          name: user.name,
          programmeId: user.occupationId,
          email: user.email,
          privacyActivated: user.privacyActivated,
          password: user.encodedPasscode,
        ),
      ),
      UserModel.fromResponse,
    );
  }

  /// Request account deletion for the currently logged in user.
  Future<Either<NetworkFailure, Unit>> requestAccountDeletion() async {
    return executor.executeAndMap(
      apiV2.apiV2AccountDelete,
      (_) => unit,
    );
  }
}
