import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/widgets/components/card.dart';
import 'package:coffeecard/widgets/components/helpers/shimmer_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class StatisticsCard extends CardBase {
  final String title;
  final int? rank;

  StatisticsCard({required this.title, this.rank})
      : super(
          dense: true,
          gap: 24,
          color: AppColor.white,
          top: CardTitle(
            title: Text(
              title,
              style: AppTextStyle.settingKey,
            ),
          ),
          bottom: CardBottomRow(
            right: ShimmerBuilder(
              showShimmer: rank == null,
              builder: (context, colorIfShimmer) {
                return Container(
                  color: colorIfShimmer,
                  child: Text.rich(
                    TextSpan(
                      text: '${rank ?? 0}',
                      style: AppTextStyle.ticketsCount,
                      children: [
                        TextSpan(
                          text: Strings.formatLeaderboardPostfix(rank ?? 0),
                          style: AppTextStyle.leaderboardScore,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
}
