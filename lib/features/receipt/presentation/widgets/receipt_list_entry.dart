import 'package:coffeecard/features/receipt/domain/entities/purchase_receipt.dart';
import 'package:coffeecard/features/receipt/domain/entities/receipt.dart';
import 'package:coffeecard/features/receipt/domain/entities/swipe_receipt.dart';
import 'package:coffeecard/features/receipt/presentation/widgets/list_entry/placeholder_receipt_list_entry.dart';
import 'package:coffeecard/features/receipt/presentation/widgets/list_entry/purchase_receipt_list_entry.dart';
import 'package:coffeecard/features/receipt/presentation/widgets/list_entry/swipe_receipt_list_entry.dart';
import 'package:flutter/material.dart';

class ReceiptListEntry extends StatelessWidget {
  final Receipt receipt;

  const ReceiptListEntry({
    required this.receipt,
  });

  @override
  Widget build(BuildContext context) {
    switch (receipt.transactionType) {
      case TransactionType.purchase:
        return PurchaseReceiptListEntry(receipt: receipt as PurchaseReceipt);
      case TransactionType.ticketSwipe:
        return SwipeReceiptListEntry(receipt: receipt as SwipeReceipt);
      case TransactionType.placeholder:
        return const PlaceholderReceiptListEntry();
    }
  }
}
