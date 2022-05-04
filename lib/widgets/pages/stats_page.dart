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
    Future<void> _refresh({required bool loadUserData}) async {
      await Future.wait([
        if (loadUserData) context.read<UserCubit>().fetchUserDetails(),
        context.read<StatisticsCubit>().refreshLeaderboards(),
      ]);
    }

    return BlocListener<UserCubit, UserState>(
      listenWhen: (_, current) => current is UserLoaded,
      listener: (context, state) => _refresh(loadUserData: false),
      child: AppScaffold.withTitle(
        title: Strings.statsPageTitle,
        body: RefreshIndicator(
          displacement: 24,
          onRefresh: () => _refresh(loadUserData: true),
          child: ListView(
            children: const [
              StatsSection(),
              LeaderboardSection(),
            ],
          ),
        ),
      ),
    );
  }
}
