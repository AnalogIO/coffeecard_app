import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/widgets/components/scaffold.dart';
import 'package:flutter/material.dart';

class FAQPage extends StatelessWidget {
  static Route get route => MaterialPageRoute(builder: (_) => FAQPage());

  @override
  Widget build(BuildContext context) {
    return AppScaffold.withTitle(
      title: Strings.faq,
      body: Container(),
    );
  }
}
