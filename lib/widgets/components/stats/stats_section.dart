import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/cubits/user/user_cubit.dart';
import 'package:coffeecard/models/account/user.dart';
import 'package:coffeecard/widgets/components/helpers/grid.dart';
import 'package:coffeecard/widgets/components/stats/stat_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class StatsSection extends StatelessWidget {
  const StatsSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        return _YourStatsGrid(user: state is UserLoaded ? state.user : null);
      },
    );
  }
}

class _YourStatsGrid extends StatelessWidget {
  const _YourStatsGrid({this.user});

  final User? user;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(Strings.statsYourStats, style: AppTextStyle.sectionTitle),
          const Gap(8),
          Grid(
            singleColumnOnSmallDevice: false,
            gap: GridGap.tightVertical,
            gapSmall: GridGap.tight,
            children: [
              StatisticsCard(
                title: Strings.statCardMonth,
                rank: user?.rankMonth,
              ),
              StatisticsCard(
                title: Strings.statCardSemester,
                rank: user?.rankSemester,
              ),
              StatisticsCard(
                title: Strings.statCardTotal,
                rank: user?.rankTotal,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
