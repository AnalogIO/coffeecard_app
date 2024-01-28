import 'package:coffeecard/core/strings.dart';
import 'package:coffeecard/features/receipt/presentation/widgets/list_entry/receipt_list_entry.dart';
import 'package:flutter/material.dart';

class PlaceholderReceiptListEntry extends StatelessWidget {
  const PlaceholderReceiptListEntry();

  @override
  Widget build(BuildContext context) {
    return ReceiptListEntry(
      tappable: false,
      productName: Strings.receiptPlaceholderName,
      menuItemName: Strings.receiptPlaceholderName,
      time: DateTime.now(),
      isPurchase: false,
      showShimmer: true,
      topText: Strings.receiptPlaceholderName,
      rightText: Strings.oneTicket,
      backgroundColor: Colors.transparent,
      status: '',
    );
  }
}
