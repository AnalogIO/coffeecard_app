import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/core/usecases/usecase.dart';
import 'package:coffeecard/features/user/domain/entities/user.dart';
import 'package:coffeecard/features/user/domain/repositories/user_repository.dart';
import 'package:dartz/dartz.dart';

class GetUser implements UseCase<User, NoParams> {
  final UserRepository repository;

  GetUser({required this.repository});

  @override
  Future<Either<Failure, User>> call(NoParams params) async {
    return repository.getUser();
  }
}
