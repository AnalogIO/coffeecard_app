import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/widgets/components/appbar_with_notification.dart';
import 'package:flutter/material.dart';

class BuyOtherPage extends StatelessWidget {
  const BuyOtherPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithNotification(title: Strings.buyOtherPageTitle),
      body: const Text('Uh oh, something was supposed to be here'),
    );
  }
}
