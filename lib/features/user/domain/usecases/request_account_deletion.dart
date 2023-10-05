import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/features/user/data/datasources/user_remote_data_source.dart';
import 'package:fpdart/fpdart.dart';

class RequestAccountDeletion {
  final UserRemoteDataSource dataSource;

  RequestAccountDeletion({required this.dataSource});

  Future<Either<Failure, Unit>> call() async {
    return dataSource.requestAccountDeletion();
  }
}
