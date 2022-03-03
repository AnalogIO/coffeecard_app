import 'package:coffeecard/cubits/statistics/statistics_cubit.dart';
import 'package:coffeecard/widgets/components/dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StatisticsDropdown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    void onChanged(StatisticsFilterCategory? category) =>
        context.read<StatisticsCubit>().fetchLeaderboards(category: category!);

    return BlocBuilder<StatisticsCubit, StatisticsState>(
      buildWhen: (previous, current) =>
          current is StatisticsLoaded || current is StatisticsLoading,
      builder: (_, state) {
        return Dropdown<StatisticsFilterCategory>(
          loading: state is StatisticsLoading,
          onChanged: onChanged,
          value: _getValue(state),
          items: _menuItems,
        );
      },
    );
  }
}

StatisticsFilterCategory _getValue(StatisticsState state) {
  if (state is StatisticsLoading) return state.filterBy;
  if (state is StatisticsLoaded) return state.filterBy;
  return StatisticsCubit.defaultFilterCategory;
}

const _menuItems = [
  DropdownMenuItem(
    value: StatisticsFilterCategory.month,
    child: Text('This month'),
  ),
  DropdownMenuItem(
    value: StatisticsFilterCategory.semester,
    child: Text('This semester'),
  ),
  DropdownMenuItem(
    value: StatisticsFilterCategory.total,
    child: Text('Of all time'),
  ),
];
