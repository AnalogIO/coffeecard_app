import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/cubits/statistics/statistics_cubit.dart';
import 'package:coffeecard/widgets/components/app_bar_title.dart';
import 'package:coffeecard/widgets/components/cards/leaderboard_card.dart';
import 'package:coffeecard/widgets/components/dropdowns/statistics_dropdown.dart';
import 'package:coffeecard/widgets/components/receipt/filter_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StatsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppBarTitle(Strings.statsPageTitle),
      ),
      body: BlocBuilder<StatisticsCubit, StatisticsState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const CircularProgressIndicator();
          } else {
            return RefreshIndicator(
              displacement: 24,
              onRefresh: context.read<StatisticsCubit>().fetchLeaderboards,
              child: ListView(
                children: [
                  /*
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
                      //FIXME: fetch data when available
                      tl: StatisticsCard(
                        Strings.statisticsTotalCupsDrunk,
                        '53',
                      ),
                      tr: StatisticsCard(
                        Strings.statisticsTotalCupsDrunkITU,
                        '106',
                      ),
                      bl: StatisticsCard(
                        Strings.statisticsYourRankITU,
                        '125th',
                      ),
                      br: StatisticsCard(
                        Strings.statisticsYourRankProgramme('BSWU'),
                        '62nd',
                      ),
                      spacing: 16,
                    ),
                    const Gap(4),
                    LeftAlignedText(
                      Strings.statisticsLeaderboards,
                      style: AppTextStyle.sectionTitle,
                    ),
                  ],
                ),
              ), */
                  FilterBar(
                    title: Strings.filter,
                    dropdown: StatisticsDropdown(),
                  ),
                  ListView.builder(
                    physics: const ScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: state.leaderboard.length,
                    itemBuilder: (context, index) {
                      final entry = state.leaderboard[index];
                      return LeaderboardCard(
                        rank: index + 1,
                        name: entry.name ?? '',
                        //FIXME: programme not available yet, implement once it is
                        programme: '',
                        cups: entry.score ?? 0,
                      );
                    },
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
