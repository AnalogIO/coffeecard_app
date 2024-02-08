import 'package:coffeecard/features/login.dart';
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
        (index) => PasscodeDot(
          isLit: index < passcodeLength,
          isError: hasError,
        ),
        growable: false,
      ),
    );
  }
}
