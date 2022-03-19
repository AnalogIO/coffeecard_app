import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/utils/time_since.dart';
import 'package:coffeecard/widgets/analog_logo.dart';
import 'package:coffeecard/widgets/components/card.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

DateFormat get _formatter => DateFormat('EEEE d/M/y HH:mm');

class ReceiptCard extends StatelessWidget {
  final String productName;
  final DateTime time;
  final bool isPurchase;
  final bool isInOverlay;
  final bool isTestEnvironment;

  const ReceiptCard({
    required this.productName,
    required this.time,
    required this.isPurchase,
    required this.isInOverlay,
    required this.isTestEnvironment,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CardBase(
        color: isTestEnvironment ? AppColor.testEnvironment : AppColor.white,
        top: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isPurchase
                  ? Strings.receiptCardPurchased
                  : Strings.receiptCardSwiped,
              style: AppTextStyle.textField,
            ),
            const Gap(16),
            Text(productName, style: AppTextStyle.ownedTicket),
            const Gap(12),
            Text(
              timeSince(time.toLocal()),
              style: AppTextStyle.textFieldBold,
            ),
            Text(
              _formatter.format(time.toLocal()),
              style: AppTextStyle.textField,
            ),
          ],
        ),
        gap: 120,
        bottom: CardBottomRow(
          gap: 48, // FIXME: Gap should be smaller on small devices
          left: isInOverlay
              ? Text(Strings.receiptCardNote, style: AppTextStyle.explainer)
              : const SizedBox.shrink(),
          right: AnalogRecieptLogo(),
        ),
      ),
    );
  }
}
