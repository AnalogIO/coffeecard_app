import 'package:coffeecard/base/style/text_styles.dart';
import 'package:flutter/material.dart';

class AppBarTitle extends StatelessWidget {
  final String title;
  const AppBarTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(title, style: AppTextStyle.pageTitle);
  }
}
