import 'package:coffeecard/base/style/colors.dart';
import 'package:flutter/material.dart';

class LoginCTA extends StatelessWidget {
  final String text;
  final void Function() onPressed;

  const LoginCTA({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: const TextStyle(
          color: AppColor.white,
          fontSize: 12,
          fontWeight: FontWeight.normal,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
