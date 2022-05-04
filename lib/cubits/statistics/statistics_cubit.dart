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
    assert(state is! StatisticsLoading); // Shouldn't be true
    emit(StatisticsLoading(filterBy: category));

    final either = await _repo.getLeaderboard(category);

    if (either.isRight) {
      emit(StatisticsLoaded(filterBy: category, leaderboard: either.right));
    } else {
      // TODO: handle failure
      emit(StatisticsFailure(errorMessage: either.left.errorMessage));
    }
  }

  /// Refresh the leaderboard without changing the filter category.
  ///
  /// If the leaderboard is not loaded yet, or an error is present,
  /// load the leaderboard with the default filter category.
  Future<void> refreshLeaderboards() async {
    final state = this.state;
    if (state is! StatisticsStateWithFilterCategory) {
      return fetchLeaderboards();
    }
    if (state is StatisticsLoaded) {
      return fetchLeaderboards(category: state.filterBy);
    }
  }
}
