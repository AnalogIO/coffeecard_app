import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/cubits/statistics/statistics_cubit.dart';
import 'package:coffeecard/cubits/user/user_cubit.dart';
import 'package:coffeecard/widgets/components/helpers/grid.dart';
import 'package:coffeecard/widgets/components/stats/stat_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class StatsSection extends StatelessWidget {
  const StatsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userCubit = context.read<UserCubit>();

    return BlocBuilder<UserCubit, UserState>(
      buildWhen: (previous, current) => previous.isLoaded != current.isLoaded,
      builder: (context, state) =>
          BlocBuilder<StatisticsCubit, StatisticsState>(
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
                Grid(
                  singleColumnOnSmallDevice: false,
                  gap: GridGap.tightVertical,
                  gapSmall: GridGap.tight,
                  children: [
                    StatisticsCard(
                      Strings.statisticsCardMonth,
                      userCubit.state.user?.rankMonth ?? -1,
                    ),
                    StatisticsCard(
                      Strings.statisticsCardSemester,
                      userCubit.state.user?.rankSemester ?? -1,
                    ),
                    StatisticsCard(
                      Strings.statisticsCardTotal,
                      userCubit.state.user?.rankTotal ?? -1,
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
