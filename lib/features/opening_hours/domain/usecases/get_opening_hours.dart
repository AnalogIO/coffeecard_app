import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/core/usecases/usecase.dart';
import 'package:coffeecard/features/opening_hours/domain/entities/timeslot.dart';
import 'package:coffeecard/features/opening_hours/domain/repositories/opening_hours_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetOpeningHours implements UseCase<Map<int, Timeslot>, NoParams> {
  final OpeningHoursRepository repository;

  GetOpeningHours({required this.repository});

  @override
  Future<Either<Failure, Map<int, Timeslot>>> call(NoParams params) async {
    return Right(repository.getOpeningHours());
  }
}
