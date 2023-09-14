import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/features/occupation/data/datasources/occupation_remote_data_source.dart';
import 'package:coffeecard/features/occupation/domain/entities/occupation.dart';
import 'package:fpdart/fpdart.dart';

class GetOccupations {
  final OccupationRemoteDataSource dataSource;

  GetOccupations({required this.dataSource});

  Future<Either<Failure, List<Occupation>>> call() {
    return dataSource.getOccupations();
  }
}
