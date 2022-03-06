import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/cubits/environment/environment_cubit.dart';
import 'package:coffeecard/utils/time_since.dart';
import 'package:coffeecard/widgets/analog_logo.dart';
import 'package:coffeecard/widgets/components/card.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

DateFormat get _formatter => DateFormat('EEEE d/M/y HH:mm');

class ReceiptCard extends CardBase with IgnorePointerCard {
  final String productName;
  final DateTime time;
  final bool isPurchase;
  final bool isInOverlay;
  final Environment env;

  ReceiptCard({
    required this.productName,
    required this.time,
    required this.isPurchase,
    required this.isInOverlay,
    required this.env,
  }) : super(
          color: env.isTest ? AppColor.testEnvironment : AppColor.white,
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
              Text(timeSince(time), style: AppTextStyle.textFieldBold),
              Text(_formatter.format(time), style: AppTextStyle.textField),
            ],
          ),
          gap: 120,
          bottom: CardBottomRow(
            gap: 48,
            left: isInOverlay
                ? Text(Strings.receiptCardNote, style: AppTextStyle.explainer)
                : const SizedBox.shrink(),
            right: AnalogRecieptLogo(),
          ),
        );
}
