import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/utils/responsive.dart';
import 'package:coffeecard/utils/time_since.dart';
import 'package:coffeecard/widgets/components/card.dart';
import 'package:coffeecard/widgets/components/images/analog_logo.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

final _formatDate = DateFormat('EEEE d/M/y HH:mm').format;

class ReceiptCard extends StatelessWidget {
  final String productName;
  final DateTime time;
  final bool isInOverlay;
  final bool isTestEnvironment;
  final String status;

  const ReceiptCard({
    required this.productName,
    required this.time,
    required this.isInOverlay,
    required this.isTestEnvironment,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final localTime = time.toLocal();

    return IgnorePointer(
      child: CardBase(
        color: isTestEnvironment
            ? AppColor.testEnvironmentReceipt
            : AppColor.white,
        top: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              status,
              style: AppTextStyle.textField,
            ),
            const Gap(16),
            Text(productName, style: AppTextStyle.ownedTicket),
            const Gap(12),
            Text(
              timeSince(localTime),
              style: AppTextStyle.textFieldBold,
            ),
            Text(
              _formatDate(localTime),
              style: AppTextStyle.textField,
            ),
          ],
        ),
        gap: 120,
        bottom: CardBottomRow(
          gap: deviceIsSmall(context) ? 24 : 48,
          left: isInOverlay
              ? Text(Strings.receiptCardNote, style: AppTextStyle.explainer)
              : const SizedBox.shrink(),
          right: AnalogReceiptLogo(),
        ),
      ),
    );
  }
}
