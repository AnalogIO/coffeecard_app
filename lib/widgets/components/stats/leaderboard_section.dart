import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/cubits/statistics/statistics_cubit.dart';
import 'package:coffeecard/cubits/user/user_cubit.dart';
import 'package:coffeecard/widgets/components/receipt/filter_bar.dart';
import 'package:coffeecard/widgets/components/section_title.dart';
import 'package:coffeecard/widgets/components/stats/leaderboard_list_view.dart';
import 'package:coffeecard/widgets/components/stats/leaderboard_list_view_placeholder.dart';
import 'package:coffeecard/widgets/components/stats/statistics_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class LeaderboardSection extends StatelessWidget {
  const LeaderboardSection({
    required this.loading,
    required this.statsState,
    required this.userState,
  });

  final bool loading;
  final StatisticsState statsState;
  final UserState userState;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Gap(16),
        const Padding(
          padding: EdgeInsets.only(left: 16),
          child: SectionTitle(Strings.statsLeaderboards),
        ),
        FilterBar(
          title: Strings.statsShowTopDrinkerFor,
          dropdown: StatisticsDropdown(),
        ),
        if (loading)
          const LeaderboardListViewPlaceholder()
        else
          LeaderboardListView(
            // if not loading, then these states must be loaded
            statsState: statsState as StatisticsLoaded,
            userState: userState as UserLoaded,
          ),
      ],
    );
  }
}
