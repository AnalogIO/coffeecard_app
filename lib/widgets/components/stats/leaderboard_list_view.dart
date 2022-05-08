import 'package:coffeecard/cubits/statistics/statistics_cubit.dart';
import 'package:coffeecard/cubits/user/user_cubit.dart';
import 'package:coffeecard/models/account/user.dart';
import 'package:coffeecard/models/leaderboard_user.dart';
import 'package:coffeecard/widgets/components/error_section.dart';
import 'package:coffeecard/widgets/components/stats/leaderboard_entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LeaderboardListView extends StatelessWidget {
  const LeaderboardListView();

  @override
  Widget build(BuildContext context) {
    final userState = context.watch<UserCubit>().state;
    final statsState = context.watch<StatisticsCubit>().state;

    if (userState is UserError) {
      return ErrorSection(
        error: userState.error,
        retry: context.read<UserCubit>().fetchUserDetails,
      );
    }

    if (statsState is StatisticsError) {
      return ErrorSection(
        error: statsState.errorMessage,
        retry: () => context.read<StatisticsCubit>().fetchLeaderboards(),
      );
    }

    if (userState is! UserLoaded || statsState is! StatisticsLoaded) {
      return const CircularProgressIndicator();
    }

    final leaderboard = statsState.leaderboard;
    final userRank = _getUserRank(userState.user, statsState.filterBy);
    final userInLeaderboard = userRank <= leaderboard.length;
    if (!userInLeaderboard) {
      // FIXME: how can we access an individual's score by id?
      leaderboard.add(LeaderboardUser(name: userState.user.name, score: 0));
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: leaderboard.length,
      itemBuilder: (context, index) {
        final entry = leaderboard[index];
        final isUsersEntry = index == userRank - 1;
        return LeaderboardEntry(
          entry.name,
          entry.score,
          index + 1,
          highlight: isUsersEntry,
        );
      },
    );
  }
}

int _getUserRank(User user, StatisticsFilterCategory filterBy) {
  if (filterBy == StatisticsFilterCategory.month) return user.rankMonth;
  if (filterBy == StatisticsFilterCategory.semester) return user.rankSemester;
  if (filterBy == StatisticsFilterCategory.total) return user.rankTotal;
  throw Exception('Unknown filter category: $filterBy');
}
