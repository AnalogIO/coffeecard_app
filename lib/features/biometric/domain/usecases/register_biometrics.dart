import 'package:coffeecard/core/strings.dart';
import 'package:coffeecard/features/authentication/data/datasources/authentication_local_data_source.dart';
import 'package:coffeecard/features/biometric/data/datasources/biometric_local_data_source.dart';
import 'package:flutter/services.dart';
import 'package:fpdart/fpdart.dart';
import 'package:local_auth/local_auth.dart';

class RegisterBiometric {
  final LocalAuthentication localAuthentication;
  final AuthenticationLocalDataSource authenticationLocalDataSource;
  final BiometricLocalDataSource biometricLocalDataSource;

  RegisterBiometric({
    required this.localAuthentication,
    required this.authenticationLocalDataSource,
    required this.biometricLocalDataSource,
  });

  Future<Either<String, void>> call() async {
    final canAuthenticateWithBiometrics =
        await localAuthentication.canCheckBiometrics;
    // ignore: unused_local_variable
    final canAuthenticate = canAuthenticateWithBiometrics ||
        await localAuthentication.isDeviceSupported();

    // ignore: unused_local_variable
    final List<BiometricType> availableBiometrics =
        await localAuthentication.getAvailableBiometrics();

    try {
      final didAuthenticate = await localAuthentication.authenticate(
        localizedReason: Strings.enableBiometricAuthentication,
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      if (didAuthenticate) {
        final user = await authenticationLocalDataSource.getAuthenticatedUser();

        return user.match(
          () => const Left('no user'),
          (user) async {
            await biometricLocalDataSource.saveCredentials(
              user.email,
              user.encodedPasscode,
            );

            return const Right(null);
          },
        );
      }

      return const Right(null);
    } on PlatformException catch (e) {
      return Left(e.message ?? Strings.unknownErrorOccured);
    }
  }
}
