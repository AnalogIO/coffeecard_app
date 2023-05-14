import 'package:coffeecard/features/receipt/domain/entities/placeholder_receipt.dart';
import 'package:coffeecard/features/receipt/domain/entities/purchase_receipt.dart';
import 'package:coffeecard/features/receipt/domain/entities/receipt.dart';
import 'package:coffeecard/features/receipt/domain/entities/swipe_receipt.dart';
import 'package:coffeecard/features/receipt/presentation/widgets/list_entry/placeholder_receipt_list_entry.dart';
import 'package:coffeecard/features/receipt/presentation/widgets/list_entry/purchase_receipt_list_entry.dart';
import 'package:coffeecard/features/receipt/presentation/widgets/list_entry/swipe_receipt_list_entry.dart';
import 'package:flutter/material.dart';

abstract class ReceiptListEntryFactory {
  static Widget create(Receipt receipt) {
    if (receipt is PlaceholderReceipt) {
      return const PlaceholderReceiptListEntry();
    }

    if (receipt is PurchaseReceipt) {
      return PurchaseReceiptListEntry(receipt: receipt);
    }

    if (receipt is SwipeReceipt) {
      return SwipeReceiptListEntry(receipt: receipt);
    }

    throw ArgumentError('unknown receipt type $receipt');
  }
}
