import 'package:coffeecard/features/receipt/domain/entities/receipt.dart';
import 'package:coffeecard/features/receipt/presentation/widgets/list_entry/placeholder_receipt_list_entry.dart';
import 'package:coffeecard/features/receipt/presentation/widgets/list_entry/purchase_receipt_list_entry.dart';
import 'package:coffeecard/features/receipt/presentation/widgets/list_entry/swipe_receipt_list_entry.dart';
import 'package:flutter/material.dart';

abstract class ReceiptListEntryFactory {
  static Widget create(Receipt receipt) => switch (receipt) {
        PlaceholderReceipt() => const PlaceholderReceiptListEntry(),
        PurchaseReceipt() => PurchaseReceiptListEntry(receipt: receipt),
        SwipeReceipt() => SwipeReceiptListEntry(receipt: receipt),
      };
}
