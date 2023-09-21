import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/base/style/app_text_styles.dart';
import 'package:coffeecard/features/leaderboard/presentation/widgets/statistics_card.dart';
import 'package:coffeecard/features/user/domain/entities/user.dart';
import 'package:coffeecard/features/user/presentation/cubit/user_cubit.dart';
import 'package:coffeecard/widgets/components/helpers/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class StatisticsSection extends StatelessWidget {
  const StatisticsSection();

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

  bool get isUserLoading => user == null;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 16, right: 16),
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
                rank: user?.rankMonth ?? 0,
                loading: isUserLoading,
              ),
              StatisticsCard(
                title: Strings.statCardSemester,
                rank: user?.rankSemester ?? 0,
                loading: isUserLoading,
              ),
              StatisticsCard(
                title: Strings.statCardTotal,
                rank: user?.rankTotal ?? 0,
                loading: isUserLoading,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
