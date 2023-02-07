import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/utils/either.dart';

abstract class OpeningHoursRepository {
  Future<Either<Failure, bool>> getIsOpen();
  Future<Either<Failure, Map<int, String>>> getOpeningHours();
}
