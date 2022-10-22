import 'package:coffeecard/data/repositories/v2/leaderboard_repository.dart';
import 'package:coffeecard/models/leaderboard_user.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'statistics_state.dart';

// FIXME: Decide on naming (StatisticsCubit vs. LeaderboardCubit)
class StatisticsCubit extends Cubit<StatisticsState> {
  StatisticsCubit(this._repo)
      : super(const StatisticsLoading(filter: LeaderboardFilter.month));

  final LeaderboardRepository _repo;

  Future<void> setFilter(LeaderboardFilter filter) async {
    emit(StatisticsLoading(filter: filter));
    fetch();
  }

  Future<void> fetch() async {
    final filter = state.filter;

    final maybeLeaderboard = await _repo.getLeaderboard(filter);
    final maybeUser = await _repo.getUserLeaderboardEntry(filter);

    if (maybeUser.isLeft) {
      emit(StatisticsError(maybeUser.left.message, filter: filter));
      return;
    }

    if (maybeLeaderboard.isLeft) {
      emit(StatisticsError(maybeLeaderboard.left.message, filter: filter));
      return;
    }

    final user = maybeUser.right;

    var userInLeaderboard = false;
    final List<LeaderboardUser> leaderboard =
        maybeLeaderboard.right.map((leaderboardUser) {
      final isCurrentUser = leaderboardUser.id == user.id;

      // set the 'found' flag if this is the current user
      if (!userInLeaderboard && isCurrentUser) {
        userInLeaderboard = true;
      }

      return LeaderboardUser(
        id: leaderboardUser.id,
        name: leaderboardUser.name,
        score: leaderboardUser.score,
        highlight: isCurrentUser,
        rank: leaderboardUser.rank,
      );
    }).toList();

    if (!userInLeaderboard) {
      leaderboard.add(
        LeaderboardUser(
          id: user.id!,
          name: user.name!,
          score: user.score!,
          highlight: true,
          rank: user.rank!,
        ),
      );
    }

    emit(StatisticsLoaded(leaderboard, filter: filter));
  }
}
