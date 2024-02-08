import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/features/authentication.dart';
import 'package:coffeecard/features/login.dart';
import 'package:fpdart/fpdart.dart';

class LoginUser {
  final AccountRemoteDataSource remoteDataSource;

  LoginUser({required this.remoteDataSource});

  Future<Either<Failure, AuthenticationInfo>> call({
    required String email,
    required String encodedPasscode,
  }) {
    return remoteDataSource.login(email, encodedPasscode);
  }
}
