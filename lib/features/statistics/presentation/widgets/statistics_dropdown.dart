import 'package:coffeecard/features/statistics/presentation/cubit/statistics_cubit.dart';
import 'package:coffeecard/widgets/components/dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StatisticsDropdown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    void onChanged(LeaderboardFilter? filter) =>
        context.read<LeaderboardCubit>().setFilter(filter!);

    return BlocBuilder<LeaderboardCubit, StatisticsState>(
      buildWhen: (previous, current) =>
          current is StatisticsLoaded || current is StatisticsLoading,
      builder: (_, state) {
        return Dropdown<LeaderboardFilter>(
          loading: state is StatisticsLoading,
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
