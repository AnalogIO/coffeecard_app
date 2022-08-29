import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/widgets/components/scaffold.dart';
import 'package:flutter/material.dart';

class FAQPage extends StatelessWidget {
  static Route get route => MaterialPageRoute(builder: (_) => FAQPage());

  static const pagePadding = EdgeInsets.symmetric(horizontal: 10);

  @override
  Widget build(BuildContext context) {
    return AppScaffold.withTitle(
      title: Strings.faq,
      body: SingleChildScrollView(
        child: Column(
          children: Strings.faqEntries.entries
              .map((e) => makeTile(e.key, e.value))
              .toList(),
        ),
      ),
    );
  }

  ExpansionTile makeTile(String title, String content) {
    return ExpansionTile(
      title: Text(
        title,
        style: AppTextStyle.sectionTitle,
      ),
      controlAffinity: ListTileControlAffinity.leading,
      expandedAlignment: Alignment.topLeft,
      tilePadding: pagePadding,
      childrenPadding: const EdgeInsets.only(bottom: 12),
      children: [
        Padding(
          padding: pagePadding,
          child: Text(
            content,
            style: AppTextStyle.settingKey,
          ),
        )
      ],
    );
  }
}
