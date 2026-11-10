import 'package:coffeecard/core/styles/app_colors.dart';
import 'package:coffeecard/core/styles/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

/// An inset, grouped list of settings with a small-caps header.
class SettingsGroup extends StatelessWidget {
  final String title;
  final List<Widget> listItems;
  final String? description;

  const SettingsGroup({
    required this.title,
    required this.listItems,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    final description = this.description;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Gap(22),
          Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 8),
            child: Semantics(
              header: true,
              child: Text(title.toUpperCase(), style: AppTextStyle.ticketLabel),
            ),
          ),
          DecoratedBox(
            position: DecorationPosition.foreground,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.border),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                // Rows draw their own bottom hairline (see ListEntry).
                children: listItems,
              ),
            ),
          ),
          if (description != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Text(description, style: AppTextStyle.explainer),
            ),
        ],
      ),
    );
  }
}
