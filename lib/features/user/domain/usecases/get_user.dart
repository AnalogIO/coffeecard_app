import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/core/usecases/usecase.dart';
import 'package:coffeecard/features/user/data/datasources/user_remote_data_source.dart';
import 'package:coffeecard/features/user/domain/entities/user.dart';
import 'package:dartz/dartz.dart';

class GetUser implements UseCase<User, NoParams> {
  final UserRemoteDataSource dataSource;

  GetUser({required this.dataSource});

  @override
  Future<Either<Failure, User>> call(NoParams params) async {
    return dataSource.getUser();
  }
}
