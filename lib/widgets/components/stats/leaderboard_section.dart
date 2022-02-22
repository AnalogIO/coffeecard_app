import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/cubits/statistics/statistics_cubit.dart';
import 'package:coffeecard/cubits/user/user_cubit.dart';
import 'package:coffeecard/errors/match_case_incomplete_exception.dart';
import 'package:coffeecard/models/account/user.dart';
import 'package:coffeecard/models/leaderboard_user.dart';
import 'package:coffeecard/widgets/components/receipt/filter_bar.dart';
import 'package:coffeecard/widgets/components/stats/leaderboard_entry.dart';
import 'package:coffeecard/widgets/components/stats/statistics_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LeaderboardSection extends StatelessWidget {
  const LeaderboardSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, userState) {
        return BlocBuilder<StatisticsCubit, StatisticsState>(
          builder: (context, statisticsState) {
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
                //FIXME: is there a nicer alternative to if-then chaining?
                if (userState is UserLoading)
                  const CircularProgressIndicator()
                else if (userState is UserLoaded)
                  if (statisticsState is StatisticsError)
                    //FIXME: display error
                    const SizedBox.shrink()
                  else if (statisticsState is StatisticsLoading)
                    const CircularProgressIndicator()
                  else if (statisticsState is StatisticsMonth)
                    createLeaderboard(
                      StatisticsFilterCategory.month,
                      statisticsState.leaderboard,
                      userState.user,
                    )
                  else if (statisticsState is StatisticsSemester)
                    createLeaderboard(
                      StatisticsFilterCategory.semester,
                      statisticsState.leaderboard,
                      userState.user,
                    )
                  else if (statisticsState is StatisticsTotal)
                    createLeaderboard(
                      StatisticsFilterCategory.total,
                      statisticsState.leaderboard,
                      userState.user,
                    )
                  else
                    throw MatchCaseIncompleteException(this)
                else if (userState is UserError)
                  //FIXME: display error
                  const SizedBox.shrink()
                else
                  throw MatchCaseIncompleteException(this)
              ],
            );
          },
        );
      },
    );
  }

  int? getUserRankByPreset(StatisticsFilterCategory category, User? user) {
    switch (category) {
      case StatisticsFilterCategory.month:
        return user?.rankMonth;
      case StatisticsFilterCategory.semester:
        return user?.rankSemester;
      case StatisticsFilterCategory.total:
        return user?.rankTotal;
    }
  }

  Column createLeaderboard(
    StatisticsFilterCategory category,
    List<LeaderboardUser> leaderboard,
    User user,
  ) {
    final int? userRank = getUserRankByPreset(
      category,
      user,
    );
    final bool userInLeaderboard =
        userRank != null && userRank <= leaderboard.length;

    return Column(
      children: [
        ListView.builder(
          physics: const ScrollPhysics(),
          shrinkWrap: true,
          itemCount: leaderboard.length,
          itemBuilder: (context, index) {
            final entry = leaderboard[index];
            final isUsersCard = userRank != null && (index == userRank - 1);
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
            user.name,
            0, //FIXME: how can we access an individual's score by id?
            userRank,
            highlight: true,
          ),
      ],
    );
  }
}
