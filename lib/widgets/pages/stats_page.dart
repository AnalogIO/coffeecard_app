import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/cubits/statistics/statistics_cubit.dart';
import 'package:coffeecard/widgets/app_scaffold.dart';
import 'package:coffeecard/widgets/components/stats/leaderboard_section.dart';
import 'package:coffeecard/widgets/components/stats/stats_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StatsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: Strings.statsPageTitle,
      body: RefreshIndicator(
        displacement: 24,
        onRefresh: context.read<StatisticsCubit>().fetchLeaderboards,
        child: ListView(
          children: const [
            StatsSection(),
            LeaderboardSection(),
          ],
        ),
      ),
    );
  }
}
