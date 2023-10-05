import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/features/register/data/datasources/register_remote_data_source.dart';
import 'package:fpdart/fpdart.dart';

class RegisterUser {
  final RegisterRemoteDataSource remoteDataSource;

  RegisterUser({required this.remoteDataSource});

  Future<Either<Failure, Unit>> call({
    required String name,
    required String email,
    required String encodedPasscode,
    required int occupationId,
  }) {
    return remoteDataSource.register(
      name,
      email,
      encodedPasscode,
      occupationId,
    );
  }
}
