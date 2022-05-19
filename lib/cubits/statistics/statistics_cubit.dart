import 'package:coffeecard/data/repositories/v1/leaderboard_repository.dart';
import 'package:coffeecard/models/leaderboard_user.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'statistics_state.dart';

class StatisticsCubit extends Cubit<StatisticsState> {
  StatisticsCubit(this._repo) : super(StatisticsInitial());

  final LeaderboardRepository _repo;
  static const defaultFilterCategory = StatisticsFilterCategory.month;

  /// Load the leaderboard with the given filter category, or the default.
  Future<void> fetchLeaderboards({
    StatisticsFilterCategory category = defaultFilterCategory,
  }) async {
    emit(StatisticsLoading(filterBy: category));
    refreshLeaderboards();
  }

  Future<void> refreshLeaderboards() async {
    // For promotion purposes
    final state = this.state;
    assert(
      state is StatisticsStateWithFilterCategory,
      'Attempted to fetch leaderboard with no filter category present',
    );

    if (state is! StatisticsStateWithFilterCategory) return;
    final category = state.filterBy;
    final either = await _repo.getLeaderboard(category);

    if (either.isRight) {
      emit(StatisticsLoaded(filterBy: category, leaderboard: either.right));
    } else {
      emit(StatisticsError(either.left.message));
    }
  }
}
