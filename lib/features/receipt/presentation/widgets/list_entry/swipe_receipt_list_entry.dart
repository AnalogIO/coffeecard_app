import 'package:animations/animations.dart';
import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/features/receipt/domain/entities/receipt.dart';
import 'package:coffeecard/features/receipt/domain/entities/swipe_receipt.dart';
import 'package:coffeecard/features/receipt/presentation/pages/view_receipt_page.dart';
import 'package:coffeecard/widgets/components/helpers/shimmer_builder.dart';
import 'package:coffeecard/widgets/components/list_entry.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final _formatter = DateFormat('dd.MM.yyyy');

class SwipeReceiptListEntry extends StatelessWidget {
  final SwipeReceipt receipt;

  const SwipeReceiptListEntry({
    required this.receipt,
  });

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
                      '${Strings.swiped} ${receipt.productName}',
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
                  Strings.oneTicket,
                  style: AppTextStyle.recieptItemValue,
                ),
              ),
              backgroundColor: AppColor.white,
            );
          },
        );
      },
    );
  }
}
