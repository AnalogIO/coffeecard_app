import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/features/occupation/domain/entities/occupation.dart';
import 'package:dartz/dartz.dart';

abstract class OccupationRepository {
  Future<Either<Failure, List<Occupation>>> getOccupations();
}
