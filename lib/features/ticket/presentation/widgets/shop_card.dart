import 'package:coffeecard/core/strings.dart';
import 'package:coffeecard/core/styles/app_colors.dart';
import 'package:coffeecard/core/styles/app_text_styles.dart';
import 'package:coffeecard/core/widgets/components/card.dart';
import 'package:flutter/material.dart';

enum ShopCardType { normal, newFeature, comingSoon }

extension _ShopCardTypeIs on ShopCardType {
  bool get isNew => this == ShopCardType.newFeature;
  bool get isComingSoon => this == ShopCardType.comingSoon;
}

class ShopCard extends StatelessWidget {
  const ShopCard({
    required this.title,
    required this.icon,
    this.type = ShopCardType.normal,
    this.onTapped,
  });

  final String title;
  final IconData icon;
  final ShopCardType type;
  final void Function(BuildContext)? onTapped;

  @override
  Widget build(BuildContext context) {
    return CardBase(
      color: type.isComingSoon ? AppColors.lightGray : AppColors.secondary,
      gap: 12,
      onTap: type.isComingSoon ? null : onTapped,
      top: Text(
        title,
        style: type.isComingSoon
            ? AppTextStyle.comingSoonShopCardTitle
            : AppTextStyle.loginTitle,
      ),
      bottom: CardBottomRow(
        gap: 8,
        left: _OptionalLabel(type: type),
        right: Icon(
          icon,
          color: type.isComingSoon ? AppColors.gray : AppColors.white,
        ),
      ),
    );
  }
}

class _OptionalLabel extends StatelessWidget {
  const _OptionalLabel({required this.type});

  final ShopCardType type;

  @override
  Widget build(BuildContext context) {
    if (type.isNew) {
      return Text(Strings.newLabel, style: AppTextStyle.newLabel);
    }
    if (type.isComingSoon) {
      return Text(Strings.comingSoonLabel, style: AppTextStyle.comingSoonLabel);
    }
    return const SizedBox.shrink();
  }
}
