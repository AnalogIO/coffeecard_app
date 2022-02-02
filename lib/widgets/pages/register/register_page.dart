import 'package:coffeecard/widgets/components/section_title.dart';
import 'package:flutter/material.dart';

abstract class RegisterPage extends StatelessWidget {
  final String sectionTitle;
  final Widget body;

  const RegisterPage({
    required this.sectionTitle,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle.register(sectionTitle),
          body,
        ],
      ),
    );
  }
}
