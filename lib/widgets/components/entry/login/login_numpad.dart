import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/cubits/login/login_cubit.dart';
import 'package:coffeecard/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show HapticFeedback;
import 'package:flutter_bloc/flutter_bloc.dart';

// TODO: disable when LoginBloc is loading (e.g. sending request)
class Numpad extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const borderInside = BorderSide(color: AppColor.lightGray, width: 2);

    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        return Container(
          color: AppColor.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            child: Table(
              border: const TableBorder(
                horizontalInside: borderInside,
                verticalInside: borderInside,
              ),
              children: const [
                TableRow(
                  children: [
                    NumpadDigitButton('1'),
                    NumpadDigitButton('2'),
                    NumpadDigitButton('3'),
                  ],
                ),
                TableRow(
                  children: [
                    NumpadDigitButton('4'),
                    NumpadDigitButton('5'),
                    NumpadDigitButton('6'),
                  ],
                ),
                TableRow(
                  children: [
                    NumpadDigitButton('7'),
                    NumpadDigitButton('8'),
                    NumpadDigitButton('9'),
                  ],
                ),
                TableRow(
                  children: [
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.fill,
                      child: NumpadActionButton(
                        icon: Icons.backspace,
                        action: NumpadAction.delete,
                      ),
                    ),
                    NumpadDigitButton('0'),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.fill,
                      child: NumpadActionButton(
                        icon: Icons.fingerprint,
                        action: NumpadAction.biometric,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class NumpadButton extends StatelessWidget {
  final void Function(BuildContext) onPressed;
  final Widget child;

  const NumpadButton({
    required this.child,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        HapticFeedback.lightImpact();
        onPressed(context);
      },
      child: child,
    );
  }
}

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

class NumpadActionButton extends StatelessWidget {
  const NumpadActionButton({
    required this.action,
    required this.icon,
  });

  final void Function(BuildContext) action;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return NumpadButton(
      onPressed: action,
      child: Icon(icon),
    );
  }
}

abstract class NumpadAction {
  static void delete(BuildContext context) {
    return context.read<LoginCubit>().clearPasscode();
  }

  static void biometric(BuildContext context) {
    throw UnimplementedError();
    // context.read<LoginBloc>().add(const LoginChangeAuthentication());
  }

  static void forgot(BuildContext context) {
    throw UnimplementedError();
    // return context.read<LoginBloc>().add(const LoginForgotPasscode());
  }
}
