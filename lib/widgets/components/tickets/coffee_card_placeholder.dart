import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class CoffeeCardPlaceholder extends StatelessWidget {
  const CoffeeCardPlaceholder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      color: AppColor.secondary,
      strokeWidth: 2,
      borderType: BorderType.RRect,
      radius: const Radius.circular(24),
      padding: const EdgeInsets.symmetric(vertical: 60),
      dashPattern: const [8, 4],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              Strings.emptyCoffeeCardTextTop,
              style: AppTextStyle.explainer,
            ),
            Text(
              Strings.emptyCoffeeCardTextBottom,
              style: AppTextStyle.explainer,
            ),
          ],
        ),
      ),
    );
  }
}
