import 'package:coffeecard/core/strings.dart';
import 'package:coffeecard/core/styles/app_colors.dart';
import 'package:coffeecard/core/styles/app_text_styles.dart';
import 'package:coffeecard/features/login/presentation/cubit/login_cubit.dart';
import 'package:coffeecard/features/login/presentation/widgets/numpad/numpad_button.dart';
import 'package:coffeecard/features/login/presentation/widgets/numpad/numpad_digit_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Numpad extends StatefulWidget {
  const Numpad({required this.forgotPasscodeAction});
  final void Function(BuildContext context) forgotPasscodeAction;

  @override
  State<Numpad> createState() => _NumpadState();
}

class _NumpadState extends State<Numpad> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _animation = Tween(begin: const Offset(0, 1), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeInOutCubicEmphasized),
      ),
    );

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _ = _controller.forward();

    const borderInside = BorderSide(color: AppColors.lightGray, width: 2);

    return SlideTransition(
      position: _animation,
      child: BlocBuilder<LoginCubit, LoginState>(
        builder: (context, state) {
          return ColoredBox(
            color: AppColors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              child: Table(
                border: const TableBorder(
                  horizontalInside: borderInside,
                  verticalInside: borderInside,
                ),
                children: [
                  const TableRow(
                    children: [
                      NumpadDigitButton('1'),
                      NumpadDigitButton('2'),
                      NumpadDigitButton('3'),
                    ],
                  ),
                  const TableRow(
                    children: [
                      NumpadDigitButton('4'),
                      NumpadDigitButton('5'),
                      NumpadDigitButton('6'),
                    ],
                  ),
                  const TableRow(
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
                        child: NumpadButton(
                          onPressed: widget.forgotPasscodeAction,
                          child: Text(
                            Strings.loginForgot,
                            style: AppTextStyle.numpadText,
                          ),
                        ),
                      ),
                      const NumpadDigitButton('0'),
                      TableCell(
                        verticalAlignment: TableCellVerticalAlignment.fill,
                        child: NumpadButton(
                          onPressed: (context) {
                            context.read<LoginCubit>().clearPasscode();
                          },
                          child: const Icon(Icons.backspace, size: 24),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
