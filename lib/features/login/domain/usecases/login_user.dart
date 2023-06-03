import 'package:coffeecard/core/data/datasources/account_remote_data_source.dart';
import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/core/usecases/usecase.dart';
import 'package:coffeecard/models/account/authenticated_user.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

class LoginUser implements UseCase<AuthenticatedUser, Params> {
  final AccountRemoteDataSource remoteDataSource;

  LoginUser({required this.remoteDataSource});

  @override
  Future<Either<Failure, AuthenticatedUser>> call(Params params) {
    return remoteDataSource.login(params.email, params.encodedPasscode);
  }
}

class Params extends Equatable {
  final String email;
  final String encodedPasscode;

  const Params({required this.email, required this.encodedPasscode});

  @override
  List<Object?> get props => [email, encodedPasscode];
}
