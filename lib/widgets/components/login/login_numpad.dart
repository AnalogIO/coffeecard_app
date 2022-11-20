import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/cubits/login/login_cubit.dart';
import 'package:coffeecard/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show HapticFeedback;
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
    _controller.forward();

    const borderInside = BorderSide(color: AppColor.lightGray, width: 2);

    return SlideTransition(
      position: _animation,
      child: BlocBuilder<LoginCubit, LoginState>(
        builder: (context, state) {
          return ColoredBox(
            color: AppColor.white,
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
                      _NumpadDigitButton('1'),
                      _NumpadDigitButton('2'),
                      _NumpadDigitButton('3'),
                    ],
                  ),
                  const TableRow(
                    children: [
                      _NumpadDigitButton('4'),
                      _NumpadDigitButton('5'),
                      _NumpadDigitButton('6'),
                    ],
                  ),
                  const TableRow(
                    children: [
                      _NumpadDigitButton('7'),
                      _NumpadDigitButton('8'),
                      _NumpadDigitButton('9'),
                    ],
                  ),
                  TableRow(
                    children: [
                      TableCell(
                        verticalAlignment: TableCellVerticalAlignment.fill,
                        child: _NumpadButton(
                          onPressed: widget.forgotPasscodeAction,
                          child: const Text(
                            'Forgot?',
                            style: AppTextStyle.numpadText,
                          ),
                        ),
                      ),
                      const _NumpadDigitButton('0'),
                      TableCell(
                        verticalAlignment: TableCellVerticalAlignment.fill,
                        child: _NumpadButton(
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

class _NumpadButton extends StatelessWidget {
  final void Function(BuildContext) onPressed;
  final Widget child;

  const _NumpadButton({
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

class _NumpadDigitButton extends StatelessWidget {
  const _NumpadDigitButton(this.digit);
  final String digit;

  @override
  Widget build(BuildContext context) {
    return _NumpadButton(
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
