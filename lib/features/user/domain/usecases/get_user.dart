import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/features/user/data/datasources/user_remote_data_source.dart';
import 'package:coffeecard/features/user/domain/entities/user.dart';
import 'package:fpdart/fpdart.dart';

class GetUser {
  final UserRemoteDataSource dataSource;

  GetUser({required this.dataSource});

  Future<Either<Failure, User>> call() {
    return dataSource.getUser();
  }
}
