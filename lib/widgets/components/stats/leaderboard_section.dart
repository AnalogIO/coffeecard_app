import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/cubits/statistics/statistics_cubit.dart';
import 'package:coffeecard/widgets/components/receipt/filter_bar.dart';
import 'package:coffeecard/widgets/components/stats/leaderboard_entry.dart';
import 'package:coffeecard/widgets/components/stats/statistics_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LeaderboardSection extends StatelessWidget {
  const LeaderboardSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StatisticsCubit, StatisticsState>(
      builder: (context, state) {
        final int? userRank = state.getUserRank();
        final bool userInLeaderboard =
            userRank != null && userRank <= state.leaderboard.length;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                Strings.statisticsLeaderboards,
                style: AppTextStyle.sectionTitle,
              ),
            ),
            FilterBar(
              title: Strings.statisticsShowTopDrinkerFor,
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
                      return LeaderboardEntry(
                        entry.name,
                        entry.score,
                        index + 1,
                        highlight: isUsersCard,
                      );
                    },
                  ),
                  if (userRank != null && !userInLeaderboard)
                    // the current user is not on the leaderboard, display them last
                    LeaderboardEntry(
                      state.user?.name ?? '',
                      0, //FIXME: how can we access an individual's score by id?
                      userRank,
                      highlight: true,
                    ),
                ],
              )
          ],
        );
      },
    );
  }
}
