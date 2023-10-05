import 'package:coffeecard/core/strings.dart';
import 'package:coffeecard/core/styles/app_colors.dart';
import 'package:coffeecard/core/styles/app_text_styles.dart';
import 'package:coffeecard/core/widgets/components/card.dart';
import 'package:flutter/material.dart';

class ShopCard extends StatelessWidget {
  const ShopCard({
    required this.title,
    required this.icon,
    required this.onTapped,
    this.optionalText,
  });

  const ShopCard.newFeature({
    required this.title,
    required this.icon,
    required this.onTapped,
  }) : optionalText = Strings.newLabel;

  final String title;
  final IconData icon;
  final void Function(BuildContext) onTapped;
  final String? optionalText;

  Widget get label {
    final optionalText = this.optionalText;
    return optionalText != null
        ? _OptionalLabel(text: optionalText)
        : const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return CardBase(
      color: AppColors.secondary,
      gap: 12,
      onTap: onTapped,
      top: Text(
        title,
        style: AppTextStyle.loginTitle,
      ),
      bottom: CardBottomRow(
        gap: 8,
        left: label,
        right: Icon(
          icon,
          color: AppColors.white,
        ),
      ),
    );
  }
}

class _OptionalLabel extends StatelessWidget {
  const _OptionalLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: AppTextStyle.shopCardOptionalLabel);
  }
}
