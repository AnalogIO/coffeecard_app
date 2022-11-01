import 'package:coffeecard/data/repositories/v1/leaderboard_repository.dart';
import 'package:coffeecard/models/leaderboard_user.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'statistics_state.dart';

// TODO: Decide on naming (StatisticsCubit vs. LeaderboardCubit)
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
    final either = await _repo.getLeaderboard(filter);
    either.caseOf(
      (error) => emit(StatisticsError(error.message, filter: filter)),
      (leaderboard) => emit(StatisticsLoaded(leaderboard, filter: filter)),
    );
  }
}
