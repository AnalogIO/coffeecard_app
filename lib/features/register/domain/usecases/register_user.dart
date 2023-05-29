import 'package:coffeecard/core/data/datasources/account_remote_data_source.dart';
import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/core/usecases/usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

class RegisterUser implements UseCase<void, Params> {
  final AccountRemoteDataSource remoteDataSource;

  RegisterUser({required this.remoteDataSource});

  @override
  Future<Either<Failure, void>> call(Params params) {
    return remoteDataSource.register(
      params.name,
      params.email,
      params.encodedPasscode,
      params.occupationId,
    );
  }
}

class Params extends Equatable {
  final String name;
  final String email;
  final String encodedPasscode;
  final int occupationId;

  const Params({
    required this.name,
    required this.email,
    required this.encodedPasscode,
    required this.occupationId,
  });

  @override
  List<Object?> get props => [name, email, encodedPasscode, occupationId];
}
