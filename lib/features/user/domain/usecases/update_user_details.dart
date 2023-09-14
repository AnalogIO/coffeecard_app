import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/features/user/data/datasources/user_remote_data_source.dart';
import 'package:coffeecard/features/user/domain/entities/user.dart';
import 'package:coffeecard/models/account/update_user.dart';
import 'package:fpdart/fpdart.dart';

class UpdateUserDetails {
  final UserRemoteDataSource dataSource;

  UpdateUserDetails({required this.dataSource});

  Future<Either<Failure, User>> call({
    required String? name,
    required String? email,
    required String? encodedPasscode,
    required bool? privacyActivated,
    required int? occupationId,
  }) async {
    return dataSource.updateUserDetails(
      UpdateUser(
        name: name,
        email: email,
        encodedPasscode: encodedPasscode,
        privacyActivated: privacyActivated,
        occupationId: occupationId,
      ),
    );
  }
}
