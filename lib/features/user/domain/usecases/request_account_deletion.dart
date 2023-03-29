import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/core/usecases/usecase.dart';
import 'package:coffeecard/features/user/data/datasources/user_remote_data_source.dart';
import 'package:dartz/dartz.dart';

class RequestAccountDeletion implements UseCase<void, NoParams> {
  final UserRemoteDataSource dataSource;

  RequestAccountDeletion({required this.dataSource});

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return dataSource.requestAccountDeletion();
  }
}
