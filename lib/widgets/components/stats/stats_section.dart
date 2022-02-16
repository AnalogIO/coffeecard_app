import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/cubits/statistics/statistics_cubit.dart';
import 'package:coffeecard/widgets/components/helpers/grid.dart';
import 'package:coffeecard/widgets/components/stats/stat_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class StatsSection extends StatelessWidget {
  const StatsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StatisticsCubit, StatisticsState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                Strings.statisticsYourStats,
                style: AppTextStyle.sectionTitle,
              ),
              const Gap(8),
              if (state.isUserStatsLoading)
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              else
                Grid(
                  singleColumnOnSmallDevice: false,
                  gap: GridGap.tightVertical,
                  gapSmall: GridGap.tight,
                  children: [
                    StatisticsCard(
                      Strings.statisticsCardMonth,
                      state.user?.rankMonth ?? 0,
                    ),
                    StatisticsCard(
                      Strings.statisticsCardSemester,
                      state.user?.rankSemester ?? 0,
                    ),
                    StatisticsCard(
                      Strings.statisticsCardTotal,
                      state.user?.rankTotal ?? 0,
                    ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }
}
