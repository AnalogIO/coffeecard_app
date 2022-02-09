import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/cubits/statistics/statistics_cubit.dart';
import 'package:coffeecard/widgets/components/dropdowns/dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StatisticsDropdown extends Dropdown {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StatisticsCubit, StatisticsState>(
      builder: (context, state) {
        return DropdownButton<StatisticsFilterCategory>(
          dropdownColor: dropdownColor,
          underline: underline,
          value: state.filterBy,
          icon: icon,
          style: style,
          onChanged: (category) {
            context.read<StatisticsCubit>().filterStatistics(category!);
          },
          items: StatisticsFilterCategory.values
              .map(
                (c) => DropdownMenuItem<StatisticsFilterCategory>(
                  value: c,
                  child: Text(c.name, style: AppTextStyle.loginExplainer),
                ),
              )
              .toList(),
        );
      },
    );
  }
}
