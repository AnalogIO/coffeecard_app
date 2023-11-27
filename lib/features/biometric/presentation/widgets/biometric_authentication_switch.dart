import 'package:coffeecard/core/styles/app_colors.dart';
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

  String email = 'test@test.dk'; //FIXME: use users email

  void handleChange(bool toggled) {
    if (toggled) {
      context.read<BiometricCubit>().register(email);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<BiometricCubit>(),
      child: BlocBuilder<BiometricCubit, BiometricState>(
        builder: (context, state) {
          return Switch(
            inactiveTrackColor: AppColors.background,
            inactiveThumbColor: AppColors.primary,
            activeTrackColor: AppColors.background,
            activeColor: AppColors.primary,
            value: enabled,
            onChanged: (v) {
              setState(() => enabled = v);
              handleChange(v);
            },
          );
        },
      ),
    );
  }
}
