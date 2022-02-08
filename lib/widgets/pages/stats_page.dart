import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/widgets/components/app_bar_title.dart';
import 'package:coffeecard/widgets/components/cards/stat_card.dart';
import 'package:coffeecard/widgets/components/grid.dart';
import 'package:coffeecard/widgets/components/left_aligned_text.dart';
import 'package:coffeecard/widgets/components/receipt/filter_bar.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class StatsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppBarTitle('Statistics'),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                LeftAlignedText(
                  'Quick stats',
                  style: AppTextStyle.sectionTitle,
                ),
                const Gap(4),
                FourGrid(
                  tl: StatisticsCard('Total cups drunk by you', '53'),
                  tr: StatisticsCard('Cups drunk by ITU today', '106'),
                  bl: StatisticsCard('Your rank this week (vs ITU)', '125th'),
                  br: StatisticsCard('Your rank this week (vs BSWU)', '62nd'),
                  spacing: 16,
                ),
                const Gap(4),
                LeftAlignedText(
                  'Leaderboards',
                  style: AppTextStyle.sectionTitle,
                ),
              ],
            ),
          ),

          //FIXME: generalize filterbar
          FilterBar(),

          //FIXME: add leaderboard
        ],
      ),
    );
  }
}
