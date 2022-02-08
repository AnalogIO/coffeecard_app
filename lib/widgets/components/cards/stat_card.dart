import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/widgets/components/cards/card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';

class StatisticsCard extends CardBase {
  final String title;
  final String value;

  StatisticsCard(this.title, this.value)
      : super(
          color: AppColor.white,
          top: Column(
            children: [
              Text(title, style: AppTextStyle.textField),
              const Gap(10),
            ],
          ),
          bottom: CardBottomRow(
            right: Text(
              value,
              style: AppTextStyle.ownedTicket,
            ),
          ),
        );
}
