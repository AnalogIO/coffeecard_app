import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/core/usecases/usecase.dart';
import 'package:coffeecard/features/occupation/data/datasources/occupation_remote_data_source.dart';
import 'package:coffeecard/features/occupation/domain/entities/occupation.dart';
import 'package:dartz/dartz.dart';

class GetOccupations implements UseCase<List<Occupation>, NoParams> {
  final OccupationRemoteDataSource dataSource;

  GetOccupations({required this.dataSource});

  @override
  Future<Either<Failure, List<Occupation>>> call(NoParams params) {
    return dataSource.getOccupations();
  }
}
