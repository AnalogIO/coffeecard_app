import 'package:coffeecard/core/styles/app_colors.dart';
import 'package:coffeecard/core/styles/app_text_styles.dart';
import 'package:flutter/material.dart';

class SettingDescription extends StatelessWidget {
  const SettingDescription({this.text, this.showArrow = true});

  final String? text;
  final bool showArrow;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (text != null)
          Flexible(
            child: Text(
              text!,
              style: AppTextStyle.settingValue,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.end,
            ),
          ),
        if (showArrow)
          const Icon(Icons.chevron_right, color: AppColors.secondary),
      ],
    );
  }
}
