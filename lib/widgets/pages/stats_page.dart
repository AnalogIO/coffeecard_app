import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/cubits/statistics/statistics_cubit.dart';
import 'package:coffeecard/cubits/user/user_cubit.dart';
import 'package:coffeecard/widgets/components/scaffold.dart';
import 'package:coffeecard/widgets/components/stats/leaderboard_section.dart';
import 'package:coffeecard/widgets/components/stats/stats_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({required this.scrollController});

  final ScrollController scrollController;

  static Route routeWith({required ScrollController scrollController}) =>
      MaterialPageRoute(
        builder: (_) => StatsPage(scrollController: scrollController),
      );

  @override
  Widget build(BuildContext context) {
    Future<void> _refresh() async {
      context.read<UserCubit>().fetchUserDetails();
      context.read<StatisticsCubit>().fetchLeaderboards();
    }

    return AppScaffold.withTitle(
      title: Strings.statsPageTitle,
      body: RefreshIndicator(
        displacement: 24,
        onRefresh: _refresh,
        child: ListView(
          controller: scrollController,
          children: const [
            StatsSection(),
            LeaderboardSection(),
          ],
        ),
      ),
    );
  }
}
