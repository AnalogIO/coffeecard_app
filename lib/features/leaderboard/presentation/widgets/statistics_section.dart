import 'package:coffeecard/core/strings.dart';
import 'package:coffeecard/core/widgets/components/section_title.dart';
import 'package:coffeecard/features/leaderboard/presentation/widgets/statistics_card.dart';
import 'package:coffeecard/features/user/domain/entities/user.dart';
import 'package:coffeecard/features/user/presentation/cubit/user_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
          const SectionTitle(Strings.statsYourRank),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: StatisticsCard(
                    title: Strings.statsFilterMonth,
                    rank: user?.rankMonth ?? 0,
                    loading: isUserLoading,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: StatisticsCard(
                    title: Strings.statsFilterSemester,
                    rank: user?.rankSemester ?? 0,
                    loading: isUserLoading,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: StatisticsCard(
                    title: Strings.statsFilterAllTime,
                    rank: user?.rankTotal ?? 0,
                    loading: isUserLoading,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
