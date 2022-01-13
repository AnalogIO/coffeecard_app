import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/widgets/components/receipt/dropdown_menu.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class FilterBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: AppColor.secondary,
      child: Row(
        children: [
          Text('Show', style: AppTextStyle.loginExplainer),
          const Gap(12),
          FilterDropdown(),
        ],
      ),
    );
  }
}
