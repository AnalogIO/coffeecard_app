import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/core/usecases/usecase.dart';
import 'package:coffeecard/features/occupation/domain/entities/occupation.dart';
import 'package:coffeecard/features/occupation/domain/repositories/occupation_repository.dart';
import 'package:dartz/dartz.dart';

class GetOccupations implements UseCase<List<Occupation>, NoParams> {
  final OccupationRepository repository;

  GetOccupations({required this.repository});

  @override
  Future<Either<Failure, List<Occupation>>> call(NoParams params) {
    return repository.getOccupations();
  }
}
