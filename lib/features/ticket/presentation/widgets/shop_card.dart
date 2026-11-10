import 'package:coffeecard/core/styles/app_colors.dart';
import 'package:coffeecard/core/styles/app_text_styles.dart';
import 'package:flutter/material.dart';

class ShopCard extends StatelessWidget {
  const ShopCard({
    required this.title,
    required this.icon,
    required this.onTapped,
    this.optionalText,
  });

  final String title;
  final IconData icon;
  final void Function(BuildContext) onTapped;

  /// Short secondary line shown under the title.
  final String? optionalText;

  @override
  Widget build(BuildContext context) {
    final optionalText = this.optionalText;
    final radius = BorderRadius.circular(24);

    return Material(
      color: AppColors.paper,
      shape: RoundedRectangleBorder(
        borderRadius: radius,
        side: const BorderSide(color: AppColors.border),
      ),
      child: InkWell(
        borderRadius: radius,
        onTap: () => onTapped(context),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: AppColors.crema,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 20, color: AppColors.espresso),
              ),
              const SizedBox(height: 14),
              Text(
                title,
                style: AppTextStyle.ui(16, weight: 600),
              ),
              if (optionalText != null) ...[
                const SizedBox(height: 2),
                Text(
                  optionalText,
                  style: AppTextStyle.ui(12, color: AppColors.grounds),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
