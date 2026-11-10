import 'package:coffeecard/core/strings.dart';
import 'package:coffeecard/core/widgets/design/analog_segmented_control.dart';
import 'package:coffeecard/features/leaderboard/presentation/cubit/leaderboard_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Chooses the period the leaderboard covers.
class StatisticsPeriodFilter extends StatelessWidget {
  const StatisticsPeriodFilter();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LeaderboardCubit, LeaderboardState>(
      buildWhen: (previous, current) =>
          current is LeaderboardLoaded || current is LeaderboardLoading,
      builder: (context, state) {
        return AnalogSegmentedControl<LeaderboardFilter>(
          enabled: state is! LeaderboardLoading,
          selected: state.filter,
          onChanged: context.read<LeaderboardCubit>().setFilter,
          segments: const [
            AnalogSegment(LeaderboardFilter.month, Strings.statsFilterMonth),
            AnalogSegment(
              LeaderboardFilter.semester,
              Strings.statsFilterSemester,
            ),
            AnalogSegment(LeaderboardFilter.total, Strings.statsFilterAllTime),
          ],
        );
      },
    );
  }
}
