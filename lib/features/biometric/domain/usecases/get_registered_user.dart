import 'package:coffeecard/features/biometric/data/datasources/biometric_local_data_source.dart';
import 'package:coffeecard/features/biometric/data/models/user_credentials.dart';
import 'package:fpdart/fpdart.dart';

class GetRegisteredUser {
  final BiometricLocalDataSource localDataSource;

  GetRegisteredUser({required this.localDataSource});

  Future<Option<UserCredentials>> call() async {
    return localDataSource.read();
  }
}
