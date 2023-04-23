import 'package:animations/animations.dart';
import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/features/receipt/presentation/pages/view_receipt_page.dart';
import 'package:coffeecard/widgets/components/helpers/shimmer_builder.dart';
import 'package:coffeecard/widgets/components/list_entry.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final _formatter = DateFormat('dd.MM.yyyy');

class PlaceholderReceiptListEntry extends StatelessWidget {
  const PlaceholderReceiptListEntry();

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      tappable: false,
      openBuilder: (context, _) {
        return ViewReceiptPage(
          name: Strings.receiptPlaceholderName,
          time: DateTime.now(),
          isPurchase: false,
        );
      },
      closedBuilder: (context, openContainer) {
        return ShimmerBuilder(
          showShimmer: true,
          builder: (context, colorIfShimmer) {
            return ListEntry(
              sideToExpand: ListEntrySide.right,
              leftWidget: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ColoredBox(
                    color: colorIfShimmer,
                    child: Text(
                      Strings.receiptPlaceholderName,
                      style: AppTextStyle.recieptItemKey,
                    ),
                  ),
                  ColoredBox(
                    color: colorIfShimmer,
                    child: Text(
                      _formatter.format(DateTime.now()),
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
              backgroundColor: Colors.transparent,
            );
          },
        );
      },
    );
  }
}
