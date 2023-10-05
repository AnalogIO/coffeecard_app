import 'package:coffeecard/core/widgets/components/dropdown.dart';
import 'package:coffeecard/features/leaderboard/presentation/cubit/leaderboard_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StatisticsDropdown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    void onChanged(LeaderboardFilter? filter) =>
        context.read<LeaderboardCubit>().setFilter(filter!);

    return BlocBuilder<LeaderboardCubit, LeaderboardState>(
      buildWhen: (previous, current) =>
          current is LeaderboardLoaded || current is LeaderboardLoading,
      builder: (_, state) {
        return Dropdown<LeaderboardFilter>(
          loading: state is LeaderboardLoading,
          onChanged: onChanged,
          value: state.filter,
          items: _menuItems,
        );
      },
    );
  }
}

const _menuItems = [
  DropdownMenuItem(
    value: LeaderboardFilter.month,
    child: Text('This month'),
  ),
  DropdownMenuItem(
    value: LeaderboardFilter.semester,
    child: Text('This semester'),
  ),
  DropdownMenuItem(
    value: LeaderboardFilter.total,
    child: Text('Of all time'),
  ),
];
