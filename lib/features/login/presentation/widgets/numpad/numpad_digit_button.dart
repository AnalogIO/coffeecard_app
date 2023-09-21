import 'package:coffeecard/core/styles/app_text_styles.dart';
import 'package:coffeecard/features/login/presentation/cubit/login_cubit.dart';
import 'package:coffeecard/features/login/presentation/widgets/numpad/numpad_button.dart';
import 'package:coffeecard/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NumpadDigitButton extends StatelessWidget {
  const NumpadDigitButton(this.digit);
  final String digit;

  @override
  Widget build(BuildContext context) {
    return NumpadButton(
      onPressed: (BuildContext context) {
        context.read<LoginCubit>().addPasscodeInput(digit);
      },
      child: Text(
        digit,
        style: deviceIsSmall(context)
            ? AppTextStyle.ticketsCount
            : AppTextStyle.numpadDigit,
      ),
    );
  }
}
