import 'package:coffeecard/core/errors/exceptions.dart';
import 'package:coffeecard/features/user/data/models/user_model.dart';
import 'package:coffeecard/generated/api/coffeecard_api.swagger.dart';
import 'package:coffeecard/generated/api/coffeecard_api_v2.swagger.dart'
    hide MessageResponseDto;
import 'package:coffeecard/models/account/update_user.dart';

abstract class UserRemoteDataSource {
  /// Get the currently logged in user.
  ///
  /// Throws a [ServerException] if the api call failed.
  Future<UserModel> getUser();

  /// Request account deletion for the currently logged in user.
  ///
  /// Throws a [ServerException] if the api call failed.
  Future<void> requestAccountDeletion();

  /// Updates the details of the currently logged in user based on
  /// the non-null details in [user]
  ///
  /// Throws a [ServerException] if the api call failed.
  Future<UserModel> updateUserDetails(UpdateUser user);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  UserRemoteDataSourceImpl({
    required this.apiV1,
    required this.apiV2,
  });

  final CoffeecardApi apiV1;
  final CoffeecardApiV2 apiV2;

  @override
  Future<UserModel> getUser() async {
    final response = await apiV2.apiV2AccountGet();

    if (!response.isSuccessful) {
      throw ServerException.fromResponse(response);
    }

    return UserModel.fromResponse(response.body!);
  }

  @override
  Future<UserModel> updateUserDetails(UpdateUser user) async {
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

  @override
  Future<void> requestAccountDeletion() async {
    final response = await apiV2.apiV2AccountDelete();

    if (!response.isSuccessful) {
      throw ServerException.fromResponse(response);
    }
  }
}
