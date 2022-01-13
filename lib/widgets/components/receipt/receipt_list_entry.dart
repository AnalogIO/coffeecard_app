import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/models/receipts/receipt.dart';
import 'package:coffeecard/widgets/components/list_entry.dart';
import 'package:coffeecard/widgets/components/receipt/receipt_overlay.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReceiptListEntry extends StatelessWidget {
  final Receipt receipt;

  DateFormat get formatter => DateFormat(
        'dd/MM-yyyy',
      ); //TODO consider if it can be stored centrally, so each entry does not end up with a copy of the formatter

  const ReceiptListEntry({
    required this.receipt,
  });

  @override
  Widget build(BuildContext context) {
    return ListEntry(
      leftWidget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            receipt.transactionType == TransactionType.purchase
                ? 'Bought ${receipt.amountPurchased} ${receipt.productName}'
                : 'Used ${receipt.productName}',
            style: AppTextStyle.recieptItemKey,
          ),
          Text(
            formatter.format(receipt.timeUsed),
            style: AppTextStyle.recieptItemDate,
          )
        ],
      ),
      rightWidget: Text(
        receipt.transactionType == TransactionType.purchase
            ? '${receipt.price},-'
            : '${receipt.price} ticket',
        style: AppTextStyle.recieptItemValue,
      ),
      onTap: () {
        ReceiptOverlay.of(context).show(receipt);
      },
      backgroundColor: receipt.transactionType == TransactionType.purchase
          ? AppColor.slightlyHighlighted
          : AppColor.white,
    );
  }
}
