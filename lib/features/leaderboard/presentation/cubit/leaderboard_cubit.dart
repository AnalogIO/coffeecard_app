import 'package:coffeecard/features/leaderboard/domain/entities/leaderboard_user.dart';
import 'package:coffeecard/features/leaderboard/domain/usecases/get_leaderboard.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'leaderboard_state.dart';

class LeaderboardCubit extends Cubit<LeaderboardState> {
  final GetLeaderboard getLeaderboard;

  LeaderboardCubit({required this.getLeaderboard})
      : super(const LeaderboardLoading(filter: LeaderboardFilter.month));

  Future<void> setFilter(LeaderboardFilter filter) async {
    emit(LeaderboardLoading(filter: filter));
    loadLeaderboard();
  }

  Future<void> loadLeaderboard() async {
    final filter = state.filter;

    final maybeLeaderboard = await getLeaderboard(filter);

    maybeLeaderboard.fold(
      (error) => emit(LeaderboardError(error.reason, filter: filter)),
      (leaderboard) => emit(LeaderboardLoaded(leaderboard, filter: filter)),
    );
  }
}
