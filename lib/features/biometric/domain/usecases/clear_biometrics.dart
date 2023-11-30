import 'package:coffeecard/features/biometric/data/datasources/biometric_local_data_source.dart';

class ClearBiometrics {
  final BiometricLocalDataSource localDataSource;

  ClearBiometrics({required this.localDataSource});

  Future<void> call() {
    return localDataSource.clearBiometrics();
  }
}
