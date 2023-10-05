import 'package:coffeecard/core/styles/app_colors.dart';
import 'package:coffeecard/core/styles/app_text_styles.dart';
import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({required this.text, required this.onTap});

  final String text;
  final void Function()? onTap;

  bool get disabled => onTap == null;

  Color _getBackgroundColor(Set<MaterialState> states) {
    if (states.contains(MaterialState.disabled)) return AppColors.lightGray;
    return AppColors.primary;
  }

  Color _getForegroundColor(Set<MaterialState> states) {
    if (states.contains(MaterialState.disabled)) return AppColors.gray;
    return AppColors.white;
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
      child: Text(
        text,
        style: disabled
            ? AppTextStyle.buttonTextDisabled
            : AppTextStyle.buttonText,
      ),
    );
  }
}
