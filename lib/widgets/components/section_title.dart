import 'package:coffeecard/base/style/app_text_styles.dart';
import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final double bottomMargin;

  const SectionTitle(this.title) : bottomMargin = 8;

  /// Section title for register screens. Has extra bottom margin.
  const SectionTitle.register(this.title) : bottomMargin = 16;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: bottomMargin),
      child: Text(
        title,
        style: AppTextStyle.sectionTitle,
      ),
    );
  }
}
