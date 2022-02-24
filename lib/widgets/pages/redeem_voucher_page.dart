import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/widgets/components/scaffold.dart';
import 'package:coffeecard/widgets/components/voucher/redeem_voucher_text_field.dart';
import 'package:flutter/material.dart';

class RedeemVoucherPage extends StatelessWidget {
  const RedeemVoucherPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppScaffold.withTitle(
      title: Strings.redeemVoucherPageTitle,
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: RedeemVoucherTextField(),
      ),
    );
  }
}
