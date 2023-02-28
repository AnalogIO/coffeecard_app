import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/features/user/domain/entities/user.dart';
import 'package:coffeecard/models/account/update_user.dart';
import 'package:dartz/dartz.dart';

abstract class UserRepository {
  Future<Either<Failure, User>> getUser();
  Future<Either<Failure, void>> requestAccountDeletion();
  Future<Either<Failure, User>> updateUserDetails(UpdateUser user);
}
