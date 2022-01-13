import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/base/style/text_styles.dart';
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
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        title: Text('Receipt', style: AppTextStyle.pageTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.save_alt),
            onPressed: () {},
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(48),
        child: ReceiptCard(
          productName: name,
          time: time,
          isPurchase: isPurchase,
          isInOverlay: false,
        ),
      ),
    );
  }
}
