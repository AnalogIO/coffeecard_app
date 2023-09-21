import 'package:coffeecard/core/styles/app_colors.dart';
import 'package:coffeecard/core/styles/app_text_styles.dart';
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
      color: AppColors.secondary,
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
