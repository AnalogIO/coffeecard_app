import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/core/usecases/usecase.dart';
import 'package:coffeecard/features/opening_hours/opening_hours.dart';
import 'package:dartz/dartz.dart';

class FetchOpeningHours implements UseCase<Map<int, String>, NoParams> {
  final OpeningHoursRepository repository;

  FetchOpeningHours({required this.repository});

  @override
  Future<Either<Failure, Map<int, String>>> call(NoParams params) async {
    return repository.getOpeningHours();
  }
}
