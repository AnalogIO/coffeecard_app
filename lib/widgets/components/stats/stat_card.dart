import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/widgets/components/card.dart';
import 'package:coffeecard/widgets/components/helpers/shimmer_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class StatisticsCard extends StatelessWidget {
  final String title;
  final int rank;
  final bool loading;

  const StatisticsCard({
    required this.title,
    required this.rank,
    required this.loading,
  });

  @override
  Widget build(BuildContext context) {
    return CardBase(
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
          showShimmer: loading,
          builder: (context, colorIfShimmer) {
            return ColoredBox(
              color: colorIfShimmer,
              child: Text.rich(
                TextSpan(
                  text: '${rank == 0 ? 'N/A' : rank}',
                  style: AppTextStyle.ticketsCount,
                  children: [
                    if (rank != 0)
                      TextSpan(
                        text: formatLeaderboardPostfix(rank),
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
}

String formatLeaderboardPostfix(int rank) {
  const def = 'th';

  if (rank > 10 && rank < 20) return def;

  switch (rank % 10) {
    case 1:
      return 'st';
    case 2:
      return 'nd';
    case 3:
      return 'rd';
    default:
      return def;
  }
}
