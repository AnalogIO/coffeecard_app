import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final Function() onPressed;
  final bool disabled;
  final Color background;
  final TextStyle? textStyle;

  const RoundedButton({
    Key? key,
    this.disabled = false,
    this.background = AppColor.primary,
    this.textStyle,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: disabled ? () => {} : onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: disabled ? AppColor.gray : background,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Text(
            text,
            style: textStyle ?? AppTextStyle.buttonText,
          ),
        ),
      ),
    );
  }
}
