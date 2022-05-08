import 'package:coffeecard/cubits/statistics/statistics_cubit.dart';
import 'package:coffeecard/cubits/user/user_cubit.dart';
import 'package:coffeecard/models/account/user.dart';
import 'package:coffeecard/models/leaderboard_user.dart';
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
    final userInLeaderboard = userRank <= leaderboard.length;
    if (!userInLeaderboard) {
      // FIXME: how can we access an individual's score by id?
      leaderboard.add(LeaderboardUser(name: userState.user.name, score: 0));
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: leaderboard.length,
      itemBuilder: (context, index) {
        final entry = leaderboard[index];
        final isUsersEntry = index == userRank - 1;
        return LeaderboardEntry(
          name: entry.name,
          score: entry.score,
          rank: index + 1,
          highlight: isUsersEntry,
        );
      },
    );
  }
}

int _getUserRank(User user, StatisticsFilterCategory filterBy) {
  if (filterBy == StatisticsFilterCategory.month) return user.rankMonth;
  if (filterBy == StatisticsFilterCategory.semester) return user.rankSemester;
  if (filterBy == StatisticsFilterCategory.total) return user.rankTotal;
  throw Exception('Unknown filter category: $filterBy');
}
