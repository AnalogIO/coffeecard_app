import 'package:animations/animations.dart';
import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/features/receipt/presentation/pages/view_receipt_page.dart';
import 'package:coffeecard/widgets/components/helpers/shimmer_builder.dart';
import 'package:coffeecard/widgets/components/list_entry.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final _formatDateTime = DateFormat('dd/MM/y HH:mm').format;

class ReceiptListEntry extends StatelessWidget {
  final bool tappable;
  final String name;
  final DateTime time;
  final bool isPurchase;
  final bool showShimmer;
  final String topText;
  final String rightText;
  final Color backgroundColor;
  final String status;

  const ReceiptListEntry({
    required this.tappable,
    required this.name,
    required this.time,
    required this.isPurchase,
    required this.showShimmer,
    required this.topText,
    required this.rightText,
    required this.backgroundColor,
    required this.status,
  });

  TextStyle get statusTextStyle {
    return tappable
        ? AppTextStyle.receiptItemDate
        : AppTextStyle.receiptItemDate.copyWith(color: AppColor.gray);
  }

  @override
  Widget build(BuildContext context) {
    final time = this.time.toLocal();

    return OpenContainer(
      tappable: tappable,
      // Remove rounded edges
      closedShape: const RoundedRectangleBorder(),
      openBuilder: (context, _) {
        return ViewReceiptPage(
          name: name,
          time: time,
          paymentStatus: status,
        );
      },
      closedBuilder: (context, openContainer) {
        return ShimmerBuilder(
          showShimmer: showShimmer,
          builder: (context, colorIfShimmer) {
            return ListEntry(
              sideToExpand: ListEntrySide.right,
              leftWidget: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ColoredBox(
                    color: colorIfShimmer,
                    child: Text(
                      topText,
                      style: AppTextStyle.receiptItemKey,
                    ),
                  ),
                  ColoredBox(
                    color: colorIfShimmer,
                    child: Text(
                      status,
                      style: statusTextStyle,
                    ),
                  ),
                  ColoredBox(
                    color: colorIfShimmer,
                    child: Text(
                      _formatDateTime(time),
                      style: statusTextStyle,
                    ),
                  ),
                ],
              ),
              rightWidget: ColoredBox(
                color: colorIfShimmer,
                child: Text(
                  rightText,
                  style: AppTextStyle.receiptItemValue,
                ),
              ),
              backgroundColor: backgroundColor,
            );
          },
        );
      },
    );
  }
}
