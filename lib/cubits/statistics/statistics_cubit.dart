import 'package:coffeecard/data/repositories/v1/leaderboard_repository.dart';
import 'package:coffeecard/models/leaderboard_user.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'statistics_state.dart';

class StatisticsCubit extends Cubit<StatisticsState> {
  StatisticsCubit(this._repo) : super(StatisticsInitial());

  final LeaderboardRepository _repo;
  static const defaultFilterCategory = StatisticsFilterCategory.month;

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
}
