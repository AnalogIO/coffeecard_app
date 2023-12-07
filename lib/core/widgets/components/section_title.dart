import 'package:coffeecard/core/styles/app_text_styles.dart';
import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  /// A section title no side widget.
  const SectionTitle(this.title) : sideWidget = null;

  /// A section title with a side widget.
  const SectionTitle.withSideWidget(this.title, {required this.sideWidget});

  final String title;
  final Widget? sideWidget;

  @override
  Widget build(BuildContext context) {
    final textWidget = Text(title, style: AppTextStyle.sectionTitle);
    final sideWidget = this.sideWidget;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: (sideWidget == null)
          ? textWidget
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [textWidget, sideWidget],
            ),
    );
  }
}
