import 'package:coffeecard/core/extensions/string_extensions.dart';
import 'package:coffeecard/core/strings.dart';
import 'package:coffeecard/core/styles/app_colors.dart';
import 'package:coffeecard/core/styles/app_text_styles.dart';
import 'package:coffeecard/core/widgets/components/dialog.dart';
import 'package:coffeecard/features/user/domain/entities/role.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class UserRoleIndicator extends StatelessWidget {
  const UserRoleIndicator(this.userRole);

  final Role userRole;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => showDialog(context),
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
          Text(
            userRole.name.capitalize(),
            style: AppTextStyle.baristaButton,
          ),
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

  Future<void> showDialog(BuildContext context) {
    return appDialog(
      context: context,
      title: userRole.name.capitalize(),
      children: [
        Text(Strings.baristaPerksExplainer, style: AppTextStyle.settingKey),
      ],
      actions: [
        TextButton(
          child: const Text(Strings.buttonGotIt),
          onPressed: () => closeAppDialog(context),
        ),
      ],
      dismissible: true,
    );
  }
}
