import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/cubits/statistics/statistics_cubit.dart';
import 'package:coffeecard/widgets/components/dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StatisticsDropdown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StatisticsCubit, StatisticsState>(
      builder: (context, state) {
        return Dropdown<StatisticsCubit, StatisticsState,
            StatisticsFilterCategory>(
          onChanged: (category) {
            context.read<StatisticsCubit>().filterStatistics(category!);
          },
          value: state.filterBy,
          items: StatisticsFilterCategory.values
              .map(
                (category) => DropdownMenuItem(
                  value: category,
                  child: Text(
                    category.name,
                    style: AppTextStyle.loginExplainer,
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }
}
