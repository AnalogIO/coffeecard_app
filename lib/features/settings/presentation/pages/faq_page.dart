import 'package:coffeecard/core/strings.dart';
import 'package:coffeecard/features/settings/presentation/widgets/faq.dart';
import 'package:coffeecard/widgets/components/scaffold.dart';
import 'package:flutter/material.dart';

class FAQPage extends StatelessWidget {
  static Route get route => MaterialPageRoute(builder: (_) => FAQPage());

  @override
  Widget build(BuildContext context) {
    return AppScaffold.withTitle(
      title: Strings.faq,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: Strings.faqEntries.entries
            .map((e) => FAQ(question: e.key, answer: e.value))
            .toList(),
      ),
    );
  }
}
