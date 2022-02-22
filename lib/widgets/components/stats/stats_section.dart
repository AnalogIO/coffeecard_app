import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/cubits/user/user_cubit.dart';
import 'package:coffeecard/errors/match_case_incomplete_exception.dart';
import 'package:coffeecard/widgets/components/helpers/grid.dart';
import 'package:coffeecard/widgets/components/stats/stat_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class StatsSection extends StatelessWidget {
  const StatsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        if (state is UserLoading) {
          return const SizedBox.shrink();
        } else if (state is UserLoaded) {
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
                      state.user.rankMonth,
                    ),
                    StatisticsCard(
                      Strings.statisticsCardSemester,
                      state.user.rankSemester,
                    ),
                    StatisticsCard(
                      Strings.statisticsCardTotal,
                      state.user.rankTotal,
                    ),
                  ],
                ),
              ],
            ),
          );
        } else if (state is UserError) {
          //FIXME: display error
          return const SizedBox.shrink();
        }

        throw MatchCaseIncompleteException(this);
      },
    );
  }
}
