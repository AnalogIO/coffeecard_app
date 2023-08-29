import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/base/style/colors.dart';
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
      name: receipt.productName,
      time: receipt.timeUsed,
      isPurchase: false,
      showShimmer: false,
      topText: receipt.productName,
      rightText: Strings.oneTicket,
      backgroundColor: AppColor.white,
      status: Strings.swiped,
    );
  }
}
