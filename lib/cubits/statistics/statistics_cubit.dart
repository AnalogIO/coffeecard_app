import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/data/repositories/v1/leaderboard_repository.dart';
import 'package:coffeecard/generated/api/coffeecard_api.swagger.models.swagger.dart'
    hide Exception;

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'statistics_state.dart';

class StatisticsCubit extends Cubit<StatisticsState> {
  final LeaderboardRepository _repository;

  StatisticsCubit(this._repository) : super(StatisticsState());

  void filterStatistics(StatisticsFilterCategory filterBy) {
    if (filterBy == state.filterBy) return;
    emit(
      state.copyWith(
        filterBy: filterBy,
      ),
    );

    fetchLeaderboards();
  }

  Future<void> fetchLeaderboards() async {
    final preset = state.filterBy == StatisticsFilterCategory.month
        ? 0
        : (state.filterBy == StatisticsFilterCategory.semester ? 1 : 2);

    final either = await _repository.getLeaderboard(preset);
    if (either.isRight) {
      emit(
        state.copyWith(
          leaderboard: either.right,
        ),
      );
    } else {
      emit(
        state.copyWith(
          leaderboard: [],
        ),
      );
    }
  }
}
