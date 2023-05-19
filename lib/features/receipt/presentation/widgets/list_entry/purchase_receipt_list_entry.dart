import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/features/receipt/domain/entities/receipt.dart';
import 'package:coffeecard/features/receipt/presentation/widgets/list_entry/receipt_list_entry.dart';
import 'package:flutter/material.dart';

class PurchaseReceiptListEntry extends StatelessWidget {
  final PurchaseReceipt receipt;

  const PurchaseReceiptListEntry({
    required this.receipt,
  });

  @override
  Widget build(BuildContext context) {
    return ReceiptListEntry(
      tappable: true,
      name: receipt.productName,
      time: receipt.timeUsed,
      isPurchase: true,
      showShimmer: false,
      topText:
          '${Strings.purchased} ${receipt.amountPurchased} ${receipt.productName}',
      rightText: '${receipt.price},-',
      backgroundColor: AppColor.slightlyHighlighted,
    );
  }
}
