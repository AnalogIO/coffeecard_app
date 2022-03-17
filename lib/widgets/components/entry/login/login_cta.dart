import 'package:coffeecard/base/style/colors.dart';
import 'package:flutter/material.dart';

class LoginCTA extends StatelessWidget {
  final String text;
  final void Function(BuildContext) onPressed;

  const LoginCTA({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

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
          color: AppColor.white,
          fontSize: 12,
          fontWeight: FontWeight.normal,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
