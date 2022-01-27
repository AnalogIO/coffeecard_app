import 'package:animations/animations.dart';
import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/widgets/components/helpers/shimmer_builder.dart';
import 'package:coffeecard/widgets/components/list_entry.dart';
import 'package:coffeecard/widgets/pages/receipts/view_receipt_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final _formatter = DateFormat('dd.MM.yyyy');

class ReceiptListEntry extends StatelessWidget {
  final bool isPlaceholder;
  final String productName;
  final bool isPurchase;
  final DateTime time;
  final int quantity;
  final int price;

  const ReceiptListEntry.swipe({
    required this.productName,
    required this.time,
  })  : isPlaceholder = false,
        isPurchase = false,
        quantity = 1,
        price = -1;

  const ReceiptListEntry.purchase({
    required this.productName,
    required this.time,
    required this.quantity,
    required this.price,
  })  : isPlaceholder = false,
        isPurchase = true;

  ReceiptListEntry.placeholder()
      : isPlaceholder = true,
        productName = Strings.receiptPlaceholderName,
        isPurchase = false,
        time = DateTime.now(),
        quantity = 1,
        price = -1;

  Color get _backgroundColor {
    if (isPlaceholder) return Colors.transparent;
    return isPurchase ? AppColor.slightlyHighlighted : AppColor.white;
  }

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      tappable: !isPlaceholder,
      openBuilder: (context, _) {
        return ViewReceiptPage(
          name: productName,
          time: time,
          isPurchase: isPurchase,
        );
      },
      closedBuilder: (context, openContainer) {
        return ShimmerBuilder(
          showShimmer: isPlaceholder,
          builder: (context, colorIfShimmer) {
            return ListEntry(
              leftWidget: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    color: colorIfShimmer,
                    child: Text(
                      isPurchase
                          ? '${Strings.purchased} $quantity $productName'
                          : '${Strings.swiped} $productName',
                      style: AppTextStyle.recieptItemKey,
                    ),
                  ),
                  Container(
                    color: colorIfShimmer,
                    child: Text(
                      _formatter.format(time),
                      style: AppTextStyle.recieptItemDate,
                    ),
                  )
                ],
              ),
              rightWidget: Container(
                color: colorIfShimmer,
                child: Text(
                  isPurchase ? '$price,-' : Strings.oneTicket,
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
