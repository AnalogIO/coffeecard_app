import 'package:coffeecard/cubits/statistics/statistics_cubit.dart';
import 'package:coffeecard/cubits/user/user_cubit.dart';
import 'package:coffeecard/models/account/user.dart';
import 'package:coffeecard/widgets/components/stats/leaderboard_entry.dart';
import 'package:flutter/material.dart';

class LeaderboardListView extends StatelessWidget {
  const LeaderboardListView({
    required this.statsState,
    required this.userState,
  });

  final StatisticsLoaded statsState;
  final UserLoaded userState;

  @override
  Widget build(BuildContext context) {
    final leaderboard = statsState.leaderboard;
    final userRank = _getUserRank(userState.user, statsState.filterBy);

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: leaderboard.length,
      itemBuilder: (context, index) {
        final entry = leaderboard[index];
        return LeaderboardEntry(
          name: entry.name,
          score: entry.score,
          rank: index + 1,
          highlight: index == userRank - 1,
        );
      },
    );
  }
}

int _getUserRank(User user, StatisticsFilterCategory filterBy) {
  switch (filterBy) {
    case StatisticsFilterCategory.month:
      return user.rankMonth;
    case StatisticsFilterCategory.semester:
      return user.rankSemester;
    case StatisticsFilterCategory.total:
      return user.rankTotal;
  }
}
