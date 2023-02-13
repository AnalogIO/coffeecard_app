import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/core/usecases/usecase.dart';
import 'package:coffeecard/features/opening_hours/domain/repositories/opening_hours_repository.dart';
import 'package:dartz/dartz.dart';

class GetIsOpen implements UseCase<bool, NoParams> {
  final OpeningHoursRepository repository;

  GetIsOpen({required this.repository});

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    return repository.getIsOpen();
  }
}
