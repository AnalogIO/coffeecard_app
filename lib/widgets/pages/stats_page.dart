import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/cubits/statistics/statistics_cubit.dart';
import 'package:coffeecard/cubits/user/user_cubit.dart';
import 'package:coffeecard/widgets/components/error_section.dart';
import 'package:coffeecard/widgets/components/scaffold.dart';
import 'package:coffeecard/widgets/components/stats/leaderboard_section.dart';
import 'package:coffeecard/widgets/components/stats/stats_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({required this.scrollController});

  final ScrollController scrollController;

  static Route routeWith({required ScrollController scrollController}) {
    return MaterialPageRoute(
      builder: (_) => StatsPage(scrollController: scrollController),
    );
  }

  @override
  Widget build(BuildContext context) {
    Future<void> refresh({required bool loadUserData}) async {
      await Future.wait([

        context.read<LeaderboardCubit>().fetch(),
      ]);
    }

    final userState = context.watch<UserCubit>().state;
    final statsState = context.watch<LeaderboardCubit>().state;
    final loading = userState is! UserLoaded || statsState is! StatisticsLoaded;

    if (userState is UserError) {
      return ErrorSection(
        center: true,
        error: userState.error,
        retry: context.read<UserCubit>().fetchUserDetails,
      );
    }

    if (statsState is StatisticsError) {
      return ErrorSection(
        center: true,
        error: statsState.errorMessage,
        retry: () => context.read<LeaderboardCubit>().fetch(),
      );
    }

    return BlocListener<UserCubit, UserState>(
      listenWhen: (_, current) => current is UserLoaded,
      listener: (context, state) => refresh(loadUserData: false),
      child: AppScaffold.withTitle(
        title: Strings.statsPageTitle,
        body: RefreshIndicator(
          displacement: 24,
          onRefresh: () => refresh(loadUserData: true),
          child: ListView(
            controller: scrollController,
            physics: loading ? const NeverScrollableScrollPhysics() : null,
            children: [
              const StatsSection(),
              LeaderboardSection(
                loading: loading,
                userState: userState,
                statsState: statsState,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
