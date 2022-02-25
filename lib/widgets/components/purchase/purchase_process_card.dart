import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/widgets/components/card.dart';
import 'package:flutter/cupertino.dart';

class PurchaseProcessCard extends CardBase {
  final String title;
  final Widget bottomWidget;

  PurchaseProcessCard({
    required this.title,
    required this.bottomWidget,
  }) : super(
          color: AppColor.white,
          top: Text(title, style: AppTextStyle.textField),
          bottom: bottomWidget,
        );
}
