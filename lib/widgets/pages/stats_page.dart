import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/widgets/components/app_bar_title.dart';
import 'package:coffeecard/widgets/components/cards/stat_card.dart';
import 'package:coffeecard/widgets/components/dropdowns/statistics_dropdown.dart';
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
        title: const AppBarTitle(Strings.statsPageTitle),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                LeftAlignedText(
                  Strings.statisticsQuickstats,
                  style: AppTextStyle.sectionTitle,
                ),
                const Gap(4),
                FourGrid(
                  //FIXME: fetch data
                  tl: StatisticsCard(Strings.statisticsTotalCupsDrunk, '53'),
                  tr: StatisticsCard(
                      Strings.statisticsTotalCupsDrunkITU, '106',),
                  bl: StatisticsCard(Strings.statisticsYourRankITU, '125th'),
                  br: StatisticsCard(
                      Strings.statisticsYourRankProgramme('BSWU'), '62nd',),
                  spacing: 16,
                ),
                const Gap(4),
                LeftAlignedText(
                  Strings.statisticsLeaderboards,
                  style: AppTextStyle.sectionTitle,
                ),
              ],
            ),
          ),

          FilterBar(
            title: Strings.filter,
            dropdown: StatisticsDropdown(),
          ),

          //FIXME: add leaderboard
        ],
      ),
    );
  }
}
