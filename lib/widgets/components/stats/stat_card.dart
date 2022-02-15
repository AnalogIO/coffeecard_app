import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/widgets/components/card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class StatisticsCard extends CardBase {
  final String title;
  final int rank;

  StatisticsCard(this.title, this.rank)
      : super(
          gap: 24,
          color: AppColor.white,
          top: CardTitle(
            title: Text(
              title,
              style: AppTextStyle.settingKey,
            ),
          ),
          bottom: CardBottomRow(
            right: Text.rich(
              TextSpan(
                text: '$rank',
                style: AppTextStyle.ticketsCount,
                children: [
                  TextSpan(
                    text: Strings.formatLeaderboardPostfix(rank),
                    style: AppTextStyle.leaderboardScore,
                  ),
                ],
              ),
            ),
          ),
        );
}
