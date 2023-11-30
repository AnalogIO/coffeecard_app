import 'package:coffeecard/core/widgets/components/coffee_card_switch.dart';
import 'package:coffeecard/features/biometric/presentation/cubit/biometric_cubit.dart';
import 'package:coffeecard/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BiometricAuthenticationSwitch extends StatefulWidget {
  const BiometricAuthenticationSwitch();

  @override
  State<BiometricAuthenticationSwitch> createState() =>
      _BiometricAuthenticationSwitchState();
}

class _BiometricAuthenticationSwitchState
    extends State<BiometricAuthenticationSwitch> {
  bool enabled = false;

  void handleChange(BuildContext context, bool toggled) {
    if (toggled) {
      context.read<BiometricCubit>().register();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<BiometricCubit>()..getRegisteredUser(),
      child: BlocBuilder<BiometricCubit, BiometricState>(
        builder: (context, state) {
          return CoffeeCardSwitch(
            value: state is BiometricLoaded && state.hasEnabledBiometrics,
            onChanged: (toggled) => handleChange(
              context,
              toggled,
            ),
          );
        },
      ),
    );
  }
}
