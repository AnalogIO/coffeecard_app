import 'package:coffeecard/base/style/app_text_styles.dart';
import 'package:flutter/material.dart';

class SettingValueText extends StatelessWidget {
  final String value;

  const SettingValueText({required this.value});

  @override
  Widget build(BuildContext context) {
    return Text(
      value,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: AppTextStyle.settingValue,
    );
  }
}
