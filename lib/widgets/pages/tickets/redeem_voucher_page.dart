import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/widgets/components/app_bar_title.dart';
import 'package:flutter/material.dart';

class RedeemVoucherPage extends StatelessWidget {
  const RedeemVoucherPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppBarTitle(Strings.redeemVoucherPageTitle),
      ),
      body: const Text('Uh oh, something was supposed to be here'),
    );
  }
}
