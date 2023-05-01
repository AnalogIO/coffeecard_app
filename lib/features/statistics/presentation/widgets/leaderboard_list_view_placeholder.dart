import 'package:coffeecard/features/statistics/presentation/widgets/leaderboard_list_entry.dart';
import 'package:flutter/material.dart';

final _placeholderListEntries =
    List.generate(10, (_) => const LeaderboardListEntry.placeholder());

class LeaderboardListViewPlaceholder extends StatelessWidget {
  const LeaderboardListViewPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Column(children: _placeholderListEntries);
  }
}
