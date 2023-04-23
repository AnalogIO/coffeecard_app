import 'package:animations/animations.dart';
import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/features/receipt/domain/entities/receipt.dart';
import 'package:coffeecard/features/receipt/presentation/pages/view_receipt_page.dart';
import 'package:coffeecard/widgets/components/helpers/shimmer_builder.dart';
import 'package:coffeecard/widgets/components/list_entry.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final _formatter = DateFormat('dd.MM.yyyy');

class ReceiptListEntry extends StatelessWidget {
  final Receipt receipt;

  const ReceiptListEntry({
    required this.receipt,
  });

  Color get _backgroundColor {
    switch (receipt.transactionType) {
      case TransactionType.purchase:
        return AppColor.slightlyHighlighted;
      case TransactionType.ticketSwipe:
        return AppColor.white;
      case TransactionType.placeholder:
        return Colors.transparent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      tappable: receipt.transactionType != TransactionType.placeholder,
      openBuilder: (context, _) {
        return ViewReceiptPage(
          name: receipt.productName,
          time: receipt.timeUsed,
          isPurchase: receipt.transactionType == TransactionType.purchase,
        );
      },
      closedBuilder: (context, openContainer) {
        return ShimmerBuilder(
          showShimmer: receipt.transactionType == TransactionType.placeholder,
          builder: (context, colorIfShimmer) {
            return ListEntry(
              sideToExpand: ListEntrySide.right,
              leftWidget: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ColoredBox(
                    color: colorIfShimmer,
                    child: Text(
                      receipt.transactionType == TransactionType.purchase
                          ? '${Strings.purchased} ${receipt.amountPurchased} ${receipt.productName}'
                          : '${Strings.swiped} ${receipt.productName}',
                      style: AppTextStyle.recieptItemKey,
                    ),
                  ),
                  ColoredBox(
                    color: colorIfShimmer,
                    child: Text(
                      _formatter.format(receipt.timeUsed),
                      style: AppTextStyle.recieptItemDate,
                    ),
                  )
                ],
              ),
              rightWidget: ColoredBox(
                color: colorIfShimmer,
                child: Text(
                  receipt.transactionType == TransactionType.purchase
                      ? '${receipt.price},-'
                      : Strings.oneTicket,
                  style: AppTextStyle.recieptItemValue,
                ),
              ),
              backgroundColor: _backgroundColor,
            );
          },
        );
      },
    );
  }
}
