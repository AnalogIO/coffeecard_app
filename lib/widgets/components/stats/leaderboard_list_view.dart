import 'package:coffeecard/cubits/statistics/statistics_cubit.dart';
import 'package:coffeecard/cubits/user/user_cubit.dart';
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

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: leaderboard.length,
      itemBuilder: (context, index) {
        final entry = leaderboard[index];
        return LeaderboardEntry(
          name: entry.name,
          score: entry.score,
          // rank: index + 1,
          // highlight: index == userRank - 1,
          // TODO use new scheme like so:
          //  rank: entry.rank,
          //  highlight: entry.id == userState.user.id,
          highlight: false,
          rank: index + 1,
        );
      },
    );
  }
}
