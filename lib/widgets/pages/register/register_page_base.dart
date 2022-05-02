import 'package:coffeecard/widgets/components/section_title.dart';
import 'package:flutter/material.dart';

class RegisterPageBase extends StatelessWidget {
  const RegisterPageBase({
    required this.sectionTitle,
    required this.body,
  });

  final String sectionTitle;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        SectionTitle.register(sectionTitle),
        body,
      ],
    );
  }
}
