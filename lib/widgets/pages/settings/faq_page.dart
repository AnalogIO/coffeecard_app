import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/widgets/components/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

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

class FAQ extends StatefulWidget {
  const FAQ({required this.question, required this.answer});

  final String question;
  final String answer;

  @override
  State<FAQ> createState() => _FAQState();
}

class _FAQState extends State<FAQ> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          // Detect touch on opaque part of the tile
          behavior: HitTestBehavior.opaque,
          onTap: () => setState(() => expanded = !expanded),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedRotation(
                  duration: const Duration(milliseconds: 100),
                  turns: expanded ? 0 : -1 / 4,
                  child: const Icon(Icons.expand_more, size: 24),
                ),
                const Gap(8),
                Expanded(
                  child: Text(
                    widget.question,
                    style: AppTextStyle.sectionTitle,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (expanded)
          Padding(
            padding: const EdgeInsets.only(left: 32, bottom: 12),
            child: Text(widget.answer, style: AppTextStyle.settingKey),
          ),
        const Gap(12),
      ],
    );
  }
}
