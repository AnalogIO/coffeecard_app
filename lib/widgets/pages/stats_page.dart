import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/cubits/statistics/statistics_cubit.dart';
import 'package:coffeecard/widgets/components/app_bar_title.dart';
import 'package:coffeecard/widgets/components/stats/leaderboard_section.dart';
import 'package:coffeecard/widgets/components/stats/stats_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class StatsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppBarTitle(Strings.statsPageTitle),
      ),
      body: RefreshIndicator(
        displacement: 24,
        onRefresh: context.read<StatisticsCubit>().fetchLeaderboards,
        child: ListView(
          children: const [
            StatsSection(),
            Gap(24),
            LeaderboardSection(),
          ],
        ),
      ),
    );
  }
}
