import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/data/repositories/v1/leaderboard_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'statistics_state.dart';

class StatisticsCubit extends Cubit<StatisticsState> {
  final LeaderboardRepository _repository;

  StatisticsCubit(this._repository) : super(const StatisticsState());

  void filterStatistics(StatisticsFilterCategory filterBy) {
    if (filterBy == state.filterBy) return;
    emit(
      state.copyWith(
        filterBy: filterBy,
      ),
    );
  }

  Future<void> fetchLeaderboards() async {
    final preset = state.filterBy == StatisticsFilterCategory.month
        ? 0
        : (state.filterBy == StatisticsFilterCategory.semester ? 1 : 2);

    final either = await _repository.getLeaderboard(preset, 5);
    if (either.isRight) {
      //FIXME: emit success
    } else {
      //FIXME: emit failure
    }
  }
}
