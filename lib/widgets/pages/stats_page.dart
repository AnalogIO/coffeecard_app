import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/cubits/statistics/statistics_cubit.dart';
import 'package:coffeecard/widgets/components/app_bar_title.dart';
import 'package:coffeecard/widgets/components/dropdowns/statistics_dropdown.dart';
import 'package:coffeecard/widgets/components/helpers/grid.dart';
import 'package:coffeecard/widgets/components/left_aligned_text.dart';
import 'package:coffeecard/widgets/components/list_entry.dart';
import 'package:coffeecard/widgets/components/receipt/filter_bar.dart';
import 'package:coffeecard/widgets/components/stat_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class StatsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppBarTitle(Strings.statsPageTitle),
      ),
      body: BlocBuilder<StatisticsCubit, StatisticsState>(
        builder: (context, state) {
          final int? userRank = context.read<StatisticsCubit>().getUserRank();
          final bool userInLeaderboard =
              userRank != null && userRank <= state.leaderboard.length;

          return RefreshIndicator(
            displacement: 24,
            onRefresh: context.read<StatisticsCubit>().fetchLeaderboards,
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      LeftAlignedText(
                        Strings.statisticsYourStats,
                        style: AppTextStyle.sectionTitle,
                      ),
                      const Gap(10),
                      if (state.isUserStatsLoading)
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      else
                        Grid(
                          singleColumnOnSmallDevice: true,
                          gap: GridGap.normal,
                          gapSmall: GridGap.normal,
                          children: [
                            StatisticsCard(
                              Strings.statisticsCardMonth,
                              _formatRank(state.user?.rankMonth ?? 0),
                            ),
                            StatisticsCard(
                              Strings.statisticsCardSemester,
                              _formatRank(state.user?.rankSemester ?? 0),
                            ),
                            StatisticsCard(
                              Strings.statisticsCardTotal,
                              _formatRank(state.user?.rankTotal ?? 0),
                            ),
                          ],
                        ),
                      const Gap(10),
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
                if (state.isLeaderboardLoading)
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                else
                  Column(
                    children: [
                      ListView.builder(
                        physics: const ScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: state.leaderboard.length,
                        itemBuilder: (context, index) {
                          final entry = state.leaderboard[index];
                          final isUsersCard =
                              userRank != null && (index == userRank - 1);
                          return _createLeaderboardEntry(
                            entry.name ?? '',
                            entry.score ?? 0,
                            index + 1,
                            highlight: isUsersCard,
                          );
                        },
                      ),
                      if (userRank != null && !userInLeaderboard)
                        // the current user is not on the leaderboard, display them last
                        _createLeaderboardEntry(
                          state.user?.name ?? '',
                          0, //FIXME: how can we access an individual's score by id?
                          userRank,
                          highlight: true,
                        ),
                    ],
                  )
              ],
            ),
          );
        },
      ),
    );
  }
}

ListEntry _createLeaderboardEntry(
  String name,
  int score,
  int rank, {
  required bool highlight,
}) {
  return ListEntry(
    backgroundColor: highlight ? AppColor.slightlyHighlighted : null,
    leftWidget: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(_formatRank(rank)),
        const Gap(10),
        const CircleAvatar(),
        const Gap(10),
        LeftAlignedText(
          name,
          style: AppTextStyle.textField,
        ),
      ],
    ),
    rightWidget: Text('$score cups'),
  );
}

String _formatRank(int rank) {
  final rankStr = rank.toString();
  final lastDigit = rankStr[rankStr.length - 1];

  String postfix = 'th';
  switch (lastDigit) {
    case '1':
      postfix = 'st';
      break;
    case '2':
      postfix = 'nd';
      break;
    case '3':
      postfix = 'rd';
      break;
  }

  return '$rank$postfix';
}
