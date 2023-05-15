import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/features/leaderboard/presentation/cubit/leaderboard_cubit.dart';
import 'package:coffeecard/features/leaderboard/presentation/widgets/leaderboard_list_view.dart';
import 'package:coffeecard/features/leaderboard/presentation/widgets/leaderboard_list_view_placeholder.dart';
import 'package:coffeecard/features/leaderboard/presentation/widgets/statistics_dropdown.dart';
import 'package:coffeecard/features/receipt/presentation/widgets/filter_bar.dart';
import 'package:coffeecard/features/user/presentation/cubit/user_cubit.dart';
import 'package:coffeecard/widgets/components/section_title.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class LeaderboardSection extends StatelessWidget {
  const LeaderboardSection({
    required this.loading,
    required this.leaderboardState,
    required this.userState,
  });

  final bool loading;
  final LeaderboardState leaderboardState;
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
            statsState: leaderboardState as LeaderboardLoaded,
            userState: userState as UserLoaded,
          ),
      ],
    );
  }
}
