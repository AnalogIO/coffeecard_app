import 'package:coffeecard/core/errors/exceptions.dart';
import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/features/occupation/data/datasources/occupation_remote_data_source.dart';
import 'package:coffeecard/features/occupation/data/models/occupation_model.dart';
import 'package:coffeecard/features/occupation/domain/repositories/occupation_repository.dart';
import 'package:dartz/dartz.dart';

class OccupationRepositoryImpl implements OccupationRepository {
  final OccupationRemoteDataSource remoteDataSource;

  OccupationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<OccupationModel>>> getOccupations() async {
    try {
      final occupations = await remoteDataSource.getOccupations();

      return Right(occupations);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.error));
    }
  }
}
