import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/features/login/data/datasources/account_remote_data_source.dart';
import 'package:coffeecard/models/account/authenticated_user.dart';
import 'package:fpdart/fpdart.dart';

class LoginUser {
  final AccountRemoteDataSource remoteDataSource;

  LoginUser({required this.remoteDataSource});

  Future<Either<Failure, AuthenticatedUser>> call({
    required String email,
    required String encodedPasscode,
  }) {
    return remoteDataSource.login(email, encodedPasscode);
  }
}
