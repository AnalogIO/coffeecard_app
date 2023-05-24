import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/features/purchase/domain/entities/payment_status.dart';
import 'package:coffeecard/features/receipt/domain/entities/receipt.dart';
import 'package:coffeecard/features/receipt/presentation/widgets/list_entry/receipt_list_entry.dart';
import 'package:flutter/material.dart';

class PurchaseReceiptListEntry extends StatelessWidget {
  final PurchaseReceipt receipt;

  const PurchaseReceiptListEntry({
    required this.receipt,
  });

  String get priceText {
    final price = receipt.price;
    return switch (receipt.paymentStatus) {
      PaymentStatus.completed => '$price,-',
      PaymentStatus.awaitingPayment ||
      PaymentStatus.reserved ||
      PaymentStatus.refunded =>
        '($price,-)',
      PaymentStatus.error || PaymentStatus.rejectedPayment => '',
    };
  }

  @override
  Widget build(BuildContext context) {
    return ReceiptListEntry(
      tappable: false,
      name: receipt.productName,
      time: receipt.timeUsed,
      isPurchase: true,
      showShimmer: false,
      topText: '${receipt.amountPurchased} ${receipt.productName}',
      rightText: priceText,
      backgroundColor: receipt.paymentStatus == PaymentStatus.completed
          ? AppColor.slightlyHighlighted
          : AppColor.lightGray.withOpacity(0.5),
      status: '${receipt.paymentStatus}',
    );
  }
}
