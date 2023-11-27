import 'package:coffeecard/core/strings.dart';
import 'package:flutter/services.dart';
import 'package:fpdart/fpdart.dart';
import 'package:local_auth/local_auth.dart';

class RegisterBiometric {
  Future<Either<String, void>> call(String email) async {
    final auth = LocalAuthentication();

    final canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
    final canAuthenticate =
        canAuthenticateWithBiometrics || await auth.isDeviceSupported();

    print(canAuthenticateWithBiometrics);
    print(canAuthenticate);

    final List<BiometricType> availableBiometrics =
        await auth.getAvailableBiometrics();

    print(availableBiometrics);

    try {
      final didAuthenticate = await auth.authenticate(
        localizedReason: Strings.enableBiometricsFor(email),
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      if (didAuthenticate) {}

      return const Right(null);
    } on PlatformException catch (e) {
      return Left(e.message ?? Strings.unknownErrorOccured);
    }
  }
}
