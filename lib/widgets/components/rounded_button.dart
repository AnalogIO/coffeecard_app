import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final Function() onPressed;
  final bool disabled;

  const RoundedButton({
    Key? key,
    this.disabled = false,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: disabled
          ? TextButton.styleFrom(
              splashFactory: NoSplash.splashFactory,
            )
          : null,
      onPressed: disabled ? () => {} : onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: disabled ? AppColor.gray : AppColor.primary,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Text(
            text,
            style: AppTextStyle.buttonText,
          ),
        ),
      ),
    );
  }
}
