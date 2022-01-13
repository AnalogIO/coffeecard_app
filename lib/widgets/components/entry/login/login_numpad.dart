import 'dart:math';

import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/blocs/login/login_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show HapticFeedback;
import 'package:flutter_bloc/flutter_bloc.dart';

// TODO: disable when LoginBloc is loading (e.g. sending request)
class Numpad extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const borderInside = BorderSide(color: AppColor.lightGray, width: 2);

    final double bottomPadding = max(
      24,
      MediaQuery.of(context).padding.bottom,
    );
    final padding = EdgeInsets.only(
      top: 16,
      bottom: bottomPadding,
      left: 32,
      right: 32,
    );

    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return Container(
          color: AppColor.white,
          child: Padding(
            padding: padding,
            child: Table(
              border: const TableBorder(
                horizontalInside: borderInside,
                verticalInside: borderInside,
              ),
              children: [
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
                    // TableCell(
                    //   verticalAlignment: TableCellVerticalAlignment.fill,
                    //   child: NumpadButton(
                    //     icon: Icons.backspace,
                    //     action: NumpadActionReset(),
                    //   ),
                    // ),
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

abstract class NumpadButton extends StatelessWidget {
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

class NumpadDigitButton extends NumpadButton {
  final String digit;

  NumpadDigitButton(this.digit)
      : super(
          onPressed: (BuildContext context) {
            context.read<LoginBloc>().add(PasscodeInput(digit));
          },
          child: Text(
            digit,
            style: AppTextStyle.numpadDigit,
          ),
        );
}

class NumpadActionButton extends NumpadButton {
  final void Function(BuildContext) action;
  final IconData icon;

  NumpadActionButton({
    required this.action,
    required this.icon,
  }) : super(
          onPressed: action,
          child: Icon(icon),
        );
}

abstract class NumpadAction {
  static void delete(BuildContext context) {
    return context.read<LoginBloc>().add(const ClearPasscode());
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
