import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/widgets/components/scaffold.dart';
import 'package:flutter/material.dart';

class BuyOtherPage extends StatelessWidget {
  const BuyOtherPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppScaffold.withTitle(
      title: Strings.buyOtherPageTitle,
      body: const Text('Uh oh, something was supposed to be here'),
    );
  }
}
