import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/features/environment/data/datasources/environment_remote_data_source.dart';
import 'package:coffeecard/features/environment/domain/entities/environment.dart';
import 'package:fpdart/fpdart.dart';

class GetEnvironmentType {
  final EnvironmentRemoteDataSource remoteDataSource;

  GetEnvironmentType({required this.remoteDataSource});

  Future<Either<Failure, Environment>> call() {
    return remoteDataSource.getEnvironmentType();
  }
}
