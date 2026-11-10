import 'package:coffeecard/core/strings.dart';
import 'package:coffeecard/core/styles/app_colors.dart';
import 'package:coffeecard/core/widgets/components/section_title.dart';
import 'package:coffeecard/features/leaderboard/presentation/cubit/leaderboard_cubit.dart';
import 'package:coffeecard/features/leaderboard/presentation/widgets/leaderboard_list_view.dart';
import 'package:coffeecard/features/leaderboard/presentation/widgets/leaderboard_list_view_placeholder.dart';
import 'package:coffeecard/features/leaderboard/presentation/widgets/statistics_period_filter.dart';
import 'package:coffeecard/features/user/presentation/cubit/user_cubit.dart';
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Gap(24),
          const SectionTitle(Strings.statsLeaderboards),
          const StatisticsPeriodFilter(),
          const Gap(12),
          DecoratedBox(
            position: DecorationPosition.foreground,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.border),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: loading
                  ? const LeaderboardListViewPlaceholder()
                  : LeaderboardListView(
                      // if not loading, then these states must be loaded
                      statsState: leaderboardState as LeaderboardLoaded,
                      userState: userState as UserLoaded,
                    ),
            ),
          ),
          const Gap(16),
        ],
      ),
    );
  }
}
