import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/widgets/components/scaffold.dart';
import 'package:coffeecard/widgets/components/receipt/receipt_card.dart';
import 'package:flutter/material.dart';

class ViewReceiptPage extends StatelessWidget {
  final String name;
  final DateTime time;
  final bool isPurchase;

  const ViewReceiptPage({
    required this.name,
    required this.time,
    required this.isPurchase,
  });

  @override
  Widget build(BuildContext context) {
    return AppScaffold.withTitle(
      title: Strings.singleReceiptPageTitle,
      body: Padding(
        padding: const EdgeInsets.all(48),
        child: IntrinsicHeight(
          child: ReceiptCard(
            productName: name,
            time: time,
            isPurchase: isPurchase,
            isInOverlay: false,
          ),
        ),
      ),
    );
  }
}
