import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/features/opening_hours/domain/entities/opening_hours.dart';
import 'package:dartz/dartz.dart';

abstract class OpeningHoursRepository {
  Future<Either<Failure, bool>> getIsOpen();
  Future<Either<Failure, OpeningHours>> getOpeningHours(int weekday);
}
