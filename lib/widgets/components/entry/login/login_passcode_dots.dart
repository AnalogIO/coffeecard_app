import 'package:coffeecard/base/style/colors.dart';
import 'package:flutter/material.dart';

class LoginPasscodeDots extends StatelessWidget {
  const LoginPasscodeDots({
    required this.passcodeLength,
    required this.hasError,
  });

  final int passcodeLength;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        4,
        (index) => _PasscodeDot(
          isLit: index < passcodeLength,
          isError: hasError,
        ),
        growable: false,
      ),
    );
  }
}

class _PasscodeDot extends StatelessWidget {
  final bool isLit;
  final bool isError;
  const _PasscodeDot({
    required this.isLit,
    required this.isError,
  });

  @override
  Widget build(BuildContext context) {
    final Color fill = isError ? AppColor.error : AppColor.white;
    final double opacity = isLit || isError ? 1 : 0.35;

    return AnimatedContainer(
      width: 20,
      height: 20,
      margin: const EdgeInsets.symmetric(horizontal: 7, vertical: 15),
      decoration: BoxDecoration(
        color: fill.withOpacity(opacity),
        shape: BoxShape.circle,
      ),
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOut,
    );
  }
}
