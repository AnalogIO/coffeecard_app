import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/features/login/data/datasources/account_remote_data_source.dart';
import 'package:fpdart/fpdart.dart';

class ResendEmail {
  final AccountRemoteDataSource remoteDataSource;

  ResendEmail({required this.remoteDataSource});

  Future<Either<Failure, void>> call(String email) async {
    return remoteDataSource.resendVerificationEmail(email);
  }
}
