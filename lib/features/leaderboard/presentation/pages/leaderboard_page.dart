import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/features/leaderboard/presentation/cubit/leaderboard_cubit.dart';
import 'package:coffeecard/features/leaderboard/presentation/widgets/leaderboard_section.dart';
import 'package:coffeecard/features/leaderboard/presentation/widgets/statistics_section.dart';
import 'package:coffeecard/features/user/presentation/cubit/user_cubit.dart';
import 'package:coffeecard/widgets/components/error_section.dart';
import 'package:coffeecard/widgets/components/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({required this.scrollController});

  final ScrollController scrollController;

  static Route routeWith({required ScrollController scrollController}) {
    return MaterialPageRoute(
      builder: (_) => StatisticsPage(scrollController: scrollController),
    );
  }

  @override
  Widget build(BuildContext context) {
    Future<void> refresh() async =>
        context.read<LeaderboardCubit>().loadLeaderboard();

    final userState = context.watch<UserCubit>().state;
    final statsState = context.watch<LeaderboardCubit>().state;
    final loading =
        userState is! UserLoaded || statsState is! LeaderboardLoaded;

    if (userState is UserError) {
      return ErrorSection(
        center: true,
        error: userState.error,
        retry: context.read<UserCubit>().fetchUserDetails,
      );
    }

    if (statsState is LeaderboardError) {
      return ErrorSection(
        center: true,
        error: statsState.errorMessage,
        retry: () => context.read<LeaderboardCubit>().loadLeaderboard(),
      );
    }

    return BlocListener<UserCubit, UserState>(
      listenWhen: (_, current) => current is UserLoaded,
      listener: (context, state) => refresh(),
      child: AppScaffold.withTitle(
        title: Strings.statsPageTitle,
        body: RefreshIndicator(
          displacement: 24,
          onRefresh: () => refresh(),
          child: ListView(
            controller: scrollController,
            physics: loading ? const NeverScrollableScrollPhysics() : null,
            children: [
              const StatisticsSection(),
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
