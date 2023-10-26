import 'package:coffeecard/core/strings.dart';
import 'package:coffeecard/core/styles/app_colors.dart';
import 'package:coffeecard/core/styles/app_text_styles.dart';
import 'package:coffeecard/core/widgets/components/dialog.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class BaristaIndicator extends StatelessWidget {
  const BaristaIndicator();

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => appDialog(
        context: context,
        title: 'Barista',
        children: [
          Text(
            Strings.baristaPerksExplainer,
            style: AppTextStyle.settingKey,
          ),
          const Gap(8),
          Text(
            Strings.baristaOnShiftDisclaimer,
            style: AppTextStyle.settingKey,
          ),
        ],
        actions: [
          TextButton(
            child: const Text(Strings.buttonGotIt),
            onPressed: () => closeAppDialog(context),
          ),
        ],
        dismissible: true,
      ),
      style: TextButton.styleFrom(
        backgroundColor: AppColors.background,
        padding: const EdgeInsets.only(left: 16, right: 12),
        shape: const StadiumBorder(),
        visualDensity: VisualDensity.compact,
        side: const BorderSide(
          color: AppColors.secondary,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Barista', style: AppTextStyle.baristaButton),
          const Gap(8),
          const Icon(
            Icons.info_outline,
            color: AppColors.secondary,
            size: 18,
          ),
        ],
      ),
    );
  }
}
