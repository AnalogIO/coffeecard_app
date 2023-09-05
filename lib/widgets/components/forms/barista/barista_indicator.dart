import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/widgets/components/dialog.dart';
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
            'As a contributor to the cafe, you have access to special perks, that you can redeem here in the app.',
            style: AppTextStyle.settingKey,
          ),
          const Gap(8),
          Text(
            'Claiming an "on-shift drink" works on the trust system, so please only claim a drink when you are actually working.',
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
        backgroundColor: AppColor.background,
        padding: const EdgeInsets.only(left: 16, right: 12),
        shape: const StadiumBorder(),
        visualDensity: VisualDensity.compact,
        side: const BorderSide(
          color: AppColor.secondary,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Barista', style: AppTextStyle.baristaButton),
          const Gap(8),
          const Icon(
            Icons.info_outline,
            color: AppColor.secondary,
            size: 18,
          ),
        ],
      ),
    );
  }
}
