import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class BiometricAuthenticationSwitch extends StatefulWidget {
  const BiometricAuthenticationSwitch({super.key});

  @override
  State<BiometricAuthenticationSwitch> createState() =>
      _BiometricAuthenticationSwitchState();
}

class _BiometricAuthenticationSwitchState
    extends State<BiometricAuthenticationSwitch> {
  bool value = false;

  String email = 'test@test.dk'; //FIXME: use users email

  Future<void> biometric() async {
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
        localizedReason: 'Enable biometrics for $email?',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      print(didAuthenticate);
    } on PlatformException catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: value,
      onChanged: (v) {
        setState(() => value = v);
        if (v) {
          biometric();
        }
      },
    );
  }
}
