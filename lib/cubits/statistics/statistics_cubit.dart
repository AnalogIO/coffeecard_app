import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/data/repositories/v1/leaderboard_repository.dart';
import 'package:coffeecard/models/account/user.dart';
import 'package:coffeecard/models/leaderboard_user.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'statistics_state.dart';

class StatisticsCubit extends Cubit<StatisticsState> {
  final LeaderboardRepository leaderboardRepository;

  StatisticsCubit(this.leaderboardRepository) : super(StatisticsState());

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
}
