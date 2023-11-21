import 'package:coffeecard/core/styles/app_colors.dart';
import 'package:coffeecard/core/styles/app_text_styles.dart';
import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({
    required this.text,
    required this.onTap,
  })  : backgroundColor = AppColors.primary,
        foregroundColor = AppColors.white;

  const RoundedButton.bright({
    required this.text,
    required this.onTap,
  })  : backgroundColor = AppColors.white,
        foregroundColor = AppColors.primary;

  final String text;
  final void Function()? onTap;
  final Color backgroundColor;
  final Color foregroundColor;

  Color _getBackgroundColor(Set<MaterialState> states) {
    return (states.contains(MaterialState.disabled))
        ? AppColors.lightGray
        : backgroundColor;
  }

  Color _getForegroundColor(Set<MaterialState> states) {
    return (states.contains(MaterialState.disabled))
        ? AppColors.gray
        : foregroundColor;
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.resolveWith(_getForegroundColor),
        maximumSize: MaterialStateProperty.all(Size.infinite),
        backgroundColor: MaterialStateProperty.resolveWith(_getBackgroundColor),
        shape: MaterialStateProperty.all(const StadiumBorder()),
        padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 16),
        ),
      ),
      onPressed: onTap,
      child: Text(text, style: AppTextStyle.buttonText),
    );
  }
}
