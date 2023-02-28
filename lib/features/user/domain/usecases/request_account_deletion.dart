import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/core/usecases/usecase.dart';
import 'package:coffeecard/features/user/domain/repositories/user_repository.dart';
import 'package:dartz/dartz.dart';

class RequestAccountDeletion implements UseCase<void, NoParams> {
  final UserRepository repository;

  RequestAccountDeletion({required this.repository});

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return repository.requestAccountDeletion();
  }
}
