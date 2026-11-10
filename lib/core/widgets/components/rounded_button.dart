import 'package:coffeecard/core/styles/app_colors.dart';
import 'package:coffeecard/core/styles/app_text_styles.dart';
import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({
    required this.text,
    required this.onTap,
  })  : backgroundColor = AppColors.espresso,
        foregroundColor = AppColors.cream;

  const RoundedButton.bright({
    required this.text,
    required this.onTap,
  })  : backgroundColor = AppColors.white,
        foregroundColor = AppColors.primary;

  final String text;
  final void Function()? onTap;
  final Color backgroundColor;
  final Color foregroundColor;

  Color _getBackgroundColor(Set<WidgetState> states) {
    return (states.contains(WidgetState.disabled))
        ? AppColors.tonal
        : backgroundColor;
  }

  Color _getForegroundColor(Set<WidgetState> states) {
    return (states.contains(WidgetState.disabled))
        ? AppColors.grounds
        : foregroundColor;
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.resolveWith(_getForegroundColor),
        minimumSize: WidgetStateProperty.all(const Size(48, 54)),
        elevation: WidgetStateProperty.all(0),
        backgroundColor: WidgetStateProperty.resolveWith(_getBackgroundColor),
        shape: WidgetStateProperty.all(const StadiumBorder()),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 16),
        ),
      ),
      onPressed: onTap,
      child: Text(text, style: AppTextStyle.buttonText),
    );
  }
}
