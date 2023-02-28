import 'package:coffeecard/core/errors/exceptions.dart';
import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/features/user/data/datasources/user_remote_data_source.dart';
import 'package:coffeecard/features/user/domain/entities/user.dart';
import 'package:coffeecard/features/user/domain/repositories/user_repository.dart';
import 'package:coffeecard/models/account/update_user.dart';
import 'package:dartz/dartz.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, User>> getUser() async {
    try {
      final user = await remoteDataSource.getUser();

      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.error));
    }
  }

  @override
  Future<Either<Failure, void>> requestAccountDeletion() async {
    try {
      await remoteDataSource.requestAccountDeletion();

      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.error));
    }
  }

  @override
  Future<Either<Failure, User>> updateUserDetails(UpdateUser user) async {
    try {
      final updatedUser = await remoteDataSource.updateUserDetails(user);

      return Right(updatedUser);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.error));
    }
  }
}
