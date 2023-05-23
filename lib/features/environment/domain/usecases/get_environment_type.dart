import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/core/usecases/usecase.dart';
import 'package:coffeecard/features/environment/data/datasources/environment_remote_data_source.dart';
import 'package:coffeecard/features/environment/domain/entities/environment.dart';
import 'package:fpdart/fpdart.dart';

class GetEnvironmentType implements UseCase<Environment, NoParams> {
  final EnvironmentRemoteDataSource remoteDataSource;

  GetEnvironmentType({required this.remoteDataSource});

  @override
  Future<Either<Failure, Environment>> call(NoParams params) {
    return remoteDataSource.getEnvironmentType();
  }
}
