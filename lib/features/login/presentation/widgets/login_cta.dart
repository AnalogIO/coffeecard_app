import 'package:coffeecard/core/styles/app_colors.dart';
import 'package:coffeecard/core/styles/app_text_styles.dart';
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
        minimumSize: WidgetStatePropertyAll(Size(44, 48)),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(
        text,
        style: AppTextStyle.ui(14, weight: 500, color: AppColors.white),
      ),
    );
  }
}
