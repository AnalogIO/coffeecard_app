import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class FilterBar extends StatelessWidget {
  final String title;
  final Widget dropdown;

  const FilterBar({required this.title, required this.dropdown});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: AppColor.secondary,
      child: Row(
        children: [
          Text(title, style: AppTextStyle.loginExplainer),
          const Gap(12),
          dropdown,
        ],
      ),
    );
  }
}
