import 'package:coffeecard/base/style/app_colors.dart';
import 'package:flutter/material.dart';

class LoginCTA extends StatelessWidget {
  const LoginCTA({required this.text, required this.onPressed});

  final String text;
  final void Function(BuildContext) onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => onPressed(context),
      style: const ButtonStyle(
        visualDensity: VisualDensity.compact,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: AppColors.white,
          fontSize: 12,
          fontWeight: FontWeight.normal,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
