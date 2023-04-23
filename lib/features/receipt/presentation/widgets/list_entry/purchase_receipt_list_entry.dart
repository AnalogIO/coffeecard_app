import 'package:animations/animations.dart';
import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/features/receipt/domain/entities/purchase_receipt.dart';
import 'package:coffeecard/features/receipt/presentation/pages/view_receipt_page.dart';
import 'package:coffeecard/widgets/components/helpers/shimmer_builder.dart';
import 'package:coffeecard/widgets/components/list_entry.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final _formatter = DateFormat('dd.MM.yyyy');

class PurchaseReceiptListEntry extends StatelessWidget {
  final PurchaseReceipt receipt;

  const PurchaseReceiptListEntry({
    required this.receipt,
  });

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      openBuilder: (context, _) {
        return ViewReceiptPage(
          name: receipt.productName,
          time: receipt.timeUsed,
          isPurchase: true,
        );
      },
      closedBuilder: (context, openContainer) {
        return ShimmerBuilder(
          showShimmer: false,
          builder: (context, colorIfShimmer) {
            return ListEntry(
              sideToExpand: ListEntrySide.right,
              leftWidget: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ColoredBox(
                    color: colorIfShimmer,
                    child: Text(
                      '${Strings.purchased} ${receipt.amountPurchased} ${receipt.productName}',
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
                  '${receipt.price},-',
                  style: AppTextStyle.recieptItemValue,
                ),
              ),
              backgroundColor: AppColor.slightlyHighlighted,
            );
          },
        );
      },
    );
  }
}
