import 'package:coffeecard/data/repositories/v2/leaderboard_repository.dart';
import 'package:coffeecard/models/leaderboard/leaderboard_user.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'statistics_state.dart';

class LeaderboardCubit extends Cubit<StatisticsState> {
  LeaderboardCubit(this._repo)
      : super(const StatisticsLoading(filter: LeaderboardFilter.month));

  final LeaderboardRepository _repo;

  Future<void> setFilter(LeaderboardFilter filter) async {
    emit(StatisticsLoading(filter: filter));
    fetch();
  }

  Future<void> fetch() async {
    final filter = state.filter;

    final maybeUser = await _repo.getLeaderboardUser(filter);

    maybeUser.fold(
      (error) => emit(StatisticsError(error.reason, filter: filter)),
      (user) async {
        final maybeLeaderboard = await _repo.getLeaderboard(filter);

        maybeLeaderboard.fold(
          (error) => emit(StatisticsError(error.reason, filter: filter)),
          (leaderboard) {
            var userInLeaderboard = false;
            final List<LeaderboardUser> users =
                leaderboard.map((leaderboardUser) {
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
              users.add(
                LeaderboardUser(
                  id: user.id,
                  name: user.name,
                  highlight: true,
                  score: user.score,
                  rank: user.rank,
                ),
              );
            }

            emit(StatisticsLoaded(users, filter: filter));
          },
        );
      },
    );
  }
}
