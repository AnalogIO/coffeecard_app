import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/data/repositories/v1/leaderboard_repository.dart';
import 'package:coffeecard/models/leaderboard_user.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'statistics_state.dart';

class StatisticsCubit extends Cubit<StatisticsState> {
  final LeaderboardRepository leaderboardRepository;

  StatisticsCubit(this.leaderboardRepository)
      : super(const StatisticsLoading());

  T switchFilterCategory<T>(
    StatisticsFilterCategory category,
    T Function() month,
    T Function() semester,
    T Function() total,
  ) {
    switch (category) {
      case StatisticsFilterCategory.month:
        return month();
      case StatisticsFilterCategory.semester:
        return semester();
      case StatisticsFilterCategory.total:
        return total();
    }
  }

  void filterStatistics(StatisticsFilterCategory filterBy) {
    switchFilterCategory(
      filterBy,
      () => emit(
        StatisticsMonth(),
      ),
      () => emit(
        StatisticsSemester(),
      ),
      () => emit(
        StatisticsTotal(),
      ),
    );

    fetchLeaderboardsForCurrentState();
  }

  Future<void> fetchLeaderboardsForCurrentState() async {
    var category = StatisticsFilterCategory.month;
    if (state is StatisticsTotal) {
      category = StatisticsFilterCategory.total;
    } else if (state is StatisticsSemester) {
      category = StatisticsFilterCategory.semester;
    }

    emit(StatisticsLoading(filterBy: category));

    final preset = getPreset(category);
    final either = await leaderboardRepository.getLeaderboard(preset);

    if (either.isLeft) {
      emit(StatisticsError(either.left.errorMessage));
    }

    switchFilterCategory(
      category,
      () => emit(StatisticsMonth(leaderboard: either.right)),
      () => emit(StatisticsSemester(leaderboard: either.right)),
      () => emit(
        StatisticsTotal(leaderboard: either.right),
      ),
    );
  }

  int getPreset(StatisticsFilterCategory category) {
    return switchFilterCategory(
      category,
      () => 0,
      () => 1,
      () => 2,
    );
  }
}
