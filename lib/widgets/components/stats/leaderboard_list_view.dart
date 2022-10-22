import 'package:coffeecard/cubits/statistics/statistics_cubit.dart';
import 'package:coffeecard/cubits/user/user_cubit.dart';
import 'package:coffeecard/widgets/components/stats/leaderboard_entry.dart';
import 'package:flutter/material.dart';

class LeaderboardListView extends StatelessWidget {
  final StatisticsLoaded statsState;
  final UserLoaded userState;

  const LeaderboardListView({
    required this.statsState,
    required this.userState,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: statsState.leaderboard
          .map(
            (e) => LeaderboardEntry(
              name: e.name,
              score: e.score,
              rank: e.rank,
              highlight: e.highlight,
            ),
          )
          .toList(),
    );
  }
}
