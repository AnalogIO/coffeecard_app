import 'package:coffeecard/core/strings.dart';
import 'package:coffeecard/core/styles/app_colors.dart';
import 'package:coffeecard/features/receipt/domain/entities/receipt.dart';
import 'package:coffeecard/features/receipt/presentation/widgets/list_entry/receipt_list_entry.dart';
import 'package:flutter/material.dart';

class SwipeReceiptListEntry extends StatelessWidget {
  final SwipeReceipt receipt;

  const SwipeReceiptListEntry({required this.receipt});

  @override
  Widget build(BuildContext context) {
    return ReceiptListEntry(
      tappable: true,
      productName: receipt.productName,
      menuItemName: receipt.menuItemName,
      time: receipt.timeUsed,
      isPurchase: false,
      showShimmer: false,
      topText: receipt.menuItemName,
      rightText: Strings.oneTicket,
      backgroundColor: AppColors.white,
      status: '${Strings.swiped} via ${receipt.productName} ticket',
    );
  }
}
