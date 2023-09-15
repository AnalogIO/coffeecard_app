import 'package:coffeecard/base/style/app_text_styles.dart';
import 'package:coffeecard/widgets/components/section_title.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class SettingsGroup extends StatelessWidget {
  final String title;
  final List<Widget> listItems;
  final String? description;

  const SettingsGroup({
    required this.title,
    required this.listItems,
    this.description,
  });

  List<Widget> get _groupDescription {
    // Needed for promotion
    final description = this.description;

    if (description == null) return [];
    return [
      Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
        child: Text(
          description,
          style: AppTextStyle.explainer,
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Gap(16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SectionTitle(title),
        ),
        ...listItems,
        ..._groupDescription,
      ],
    );
  }
}
