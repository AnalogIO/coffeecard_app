import 'package:coffeecard/core/widgets/components/coffee_card_switch.dart';
import 'package:coffeecard/features/biometric/presentation/cubit/biometrics_cubit.dart';
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
  void handleChange(BuildContext context, bool toggled) {
    final cubit = context.read<BiometricsCubit>();

    if (toggled) {
      cubit.register();
    } else {
      cubit.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<BiometricsCubit>()..loadBiometrics(),
      child: BlocBuilder<BiometricsCubit, BiometricsState>(
        builder: (context, state) {
          return CoffeeCardSwitch(
            value: state is BiometricsLoaded && state.hasEnabledBiometrics,
            onChanged: (toggled) => handleChange(
              context,
              toggled,
            ),
            loading: state is BiometricsLoading,
          );
        },
      ),
    );
  }
}
