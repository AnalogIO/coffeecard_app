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
    final labelStyle = AppTextStyle.numpadText.copyWith(color: AppColors.cream);

    Widget row(List<Widget> keys) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 7),
          child: Row(children: [for (final k in keys) Expanded(child: k)]),
        );

    return SlideTransition(
      position: MediaQuery.of(context).disableAnimations
          ? const AlwaysStoppedAnimation(Offset.zero)
          : _animation,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 340),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                row(const [
                  NumpadDigitButton('1'),
                  NumpadDigitButton('2'),
                  NumpadDigitButton('3'),
                ]),
                row(const [
                  NumpadDigitButton('4'),
                  NumpadDigitButton('5'),
                  NumpadDigitButton('6'),
                ]),
                row(const [
                  NumpadDigitButton('7'),
                  NumpadDigitButton('8'),
                  NumpadDigitButton('9'),
                ]),
                row([
                  NumpadButton(
                    filled: false,
                    onPressed: widget.forgotPasscodeAction,
                    child: Text(Strings.loginForgot, style: labelStyle),
                  ),
                  const NumpadDigitButton('0'),
                  NumpadButton(
                    filled: false,
                    semanticLabel: Strings.numpadDelete,
                    onPressed: (context) {
                      context.read<LoginCubit>().clearPasscode();
                    },
                    child: const Icon(
                      Icons.backspace_outlined,
                      size: 26,
                      color: AppColors.cream,
                    ),
                  ),
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
