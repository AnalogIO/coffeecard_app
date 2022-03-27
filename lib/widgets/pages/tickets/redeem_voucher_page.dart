import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/widgets/components/scaffold.dart';
import 'package:coffeecard/widgets/components/voucher/redeem_voucher_body.dart';
import 'package:flutter/material.dart';

class RedeemVoucherPage extends StatelessWidget {
  const RedeemVoucherPage();

  static Route get route =>
      MaterialPageRoute(builder: (_) => const RedeemVoucherPage());

  @override
  Widget build(BuildContext context) {
    return AppScaffold.withTitle(
      title: Strings.redeemVoucherPageTitle,
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: RedeemVoucherBody(),
      ),
    );
  }
}
