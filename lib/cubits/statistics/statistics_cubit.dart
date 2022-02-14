import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/data/repositories/v1/account_repository.dart';
import 'package:coffeecard/data/repositories/v1/leaderboard_repository.dart';
import 'package:coffeecard/generated/api/coffeecard_api.swagger.models.swagger.dart'
    hide Exception;
import 'package:coffeecard/models/account/user.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'statistics_state.dart';

class StatisticsCubit extends Cubit<StatisticsState> {
  final LeaderboardRepository leaderboardRepository;
  final AccountRepository accountRepository;

  StatisticsCubit(this.leaderboardRepository, this.accountRepository)
      : super(StatisticsState());

  void filterStatistics(StatisticsFilterCategory filterBy) {
    if (filterBy == state.filterBy) return;
    emit(
      state.copyWith(
        filterBy: filterBy,
      ),
    );

    fetchLeaderboards();
  }

  Future<void> fetchCurrentUser() async {
    emit(state.copyWith(isUserStatsLoading: true));

    final either = await accountRepository.getUser();

    if (either.isRight) {
      emit(state.copyWith(isUserStatsLoading: false, user: either.right));
    } else {
      emit(state.copyWith(isUserStatsLoading: false));
    }
  }

  Future<void> fetchLeaderboards() async {
    emit(state.copyWith(isLeaderboardLoading: true));

    final either =
        await leaderboardRepository.getLeaderboard(state.filterBy.preset);
    if (either.isRight) {
      emit(
        state.copyWith(
          leaderboard: either.right,
          isLeaderboardLoading: false,
        ),
      );
    } else {
      emit(
        state.copyWith(
          leaderboard: [],
          isLeaderboardLoading: false,
        ),
      );
    }
  }

  int? getUserRank() {
    switch (state.filterBy.preset) {
      case 0:
        return state.user?.rankMonth;
      case 1:
        return state.user?.rankSemester;
      case 2:
        return state.user?.rankTotal;
      default:
        return null;
    }
  }
}
