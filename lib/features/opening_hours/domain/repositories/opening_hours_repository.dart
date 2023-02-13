import 'package:coffeecard/core/errors/failures.dart';
import 'package:dartz/dartz.dart';

abstract class OpeningHoursRepository {
  Future<Either<Failure, bool>> getIsOpen();
  Future<Either<Failure, Map<int, String>>> getOpeningHours();
}
