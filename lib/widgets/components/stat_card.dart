import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/widgets/components/card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

//FIXME: widget for 'quick stats', not supported yet
class StatisticsCard extends CardBase {
  final String title;
  final String value;

  StatisticsCard(this.title, this.value)
      : super(
          gap: 10,
          color: AppColor.white,
          top: Column(
            children: [
              Text(title, style: AppTextStyle.textField),
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
