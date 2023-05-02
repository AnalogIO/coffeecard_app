import 'package:coffeecard/features/leaderboard/presentation/cubit/leaderboard_cubit.dart';
import 'package:coffeecard/features/leaderboard/presentation/widgets/leaderboard_list_entry.dart';
import 'package:coffeecard/features/user/presentation/cubit/user_cubit.dart';
import 'package:flutter/material.dart';

class LeaderboardListView extends StatelessWidget {
  final LeaderboardLoaded statsState;
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
            (user) => LeaderboardListEntry(
              id: user.id,
              name: user.name,
              score: user.score,
              rank: user.rank,
              highlight: user.highlight,
            ),
          )
          .toList(),
    );
  }
}
