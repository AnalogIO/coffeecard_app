import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/features/opening_hours/domain/entities/opening_hours.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class OpeningHoursRepository {
  Future<Either<Failure, OpeningHours>> getOpeningHours(int weekday);
}
