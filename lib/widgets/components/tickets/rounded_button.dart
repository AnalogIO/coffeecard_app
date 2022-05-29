import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final void Function()? onTap;

  const RoundedButton({
    Key? key,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  bool get disabled => onTap == null;

  Color _getBackgroundColor(Set<MaterialState> states) {
    if (states.contains(MaterialState.disabled)) return AppColor.lightGray;
    return AppColor.primary;
  }

  Color _getForegroundColor(Set<MaterialState> states) {
    if (states.contains(MaterialState.disabled)) return AppColor.gray;
    return AppColor.white;
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
