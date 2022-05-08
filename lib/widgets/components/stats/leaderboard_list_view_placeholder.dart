import 'package:coffeecard/widgets/components/stats/leaderboard_entry.dart';
import 'package:flutter/material.dart';

final _placeholderListEntries =
    List.generate(10, (_) => const LeaderboardEntry.placeholder());

class LeaderboardListViewPlaceholder extends StatelessWidget {
  const LeaderboardListViewPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Column(children: _placeholderListEntries);
  }
}
