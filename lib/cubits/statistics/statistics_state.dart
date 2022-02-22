part of 'statistics_cubit.dart';

enum StatisticsFilterCategory { semester, month, total }

abstract class StatisticsState extends Equatable {
  final StatisticsFilterCategory filterBy;

  const StatisticsState({StatisticsFilterCategory? filterBy})
      : filterBy = filterBy ?? StatisticsFilterCategory.month;

  @override
  List<Object?> get props => [filterBy];
}

class StatisticsLoading extends StatisticsState {
  const StatisticsLoading({StatisticsFilterCategory? filterBy})
      : super(filterBy: filterBy);
}

class StatisticsError extends StatisticsState {
  final String error;

  const StatisticsError(this.error);
}

abstract class StatisticsSuccess extends StatisticsState {
  final int preset;
  final String name;
  final List<LeaderboardUser> leaderboard;

  const StatisticsSuccess({
    required this.preset,
    required this.name,
    required this.leaderboard,
    required StatisticsFilterCategory filterBy,
  }) : super(filterBy: filterBy);

  @override
  List<Object?> get props => [preset, name, leaderboard];
}

class StatisticsMonth extends StatisticsSuccess {
  StatisticsMonth({List<LeaderboardUser>? leaderboard})
      : super(
          filterBy: StatisticsFilterCategory.month,
          preset: 0,
          leaderboard: leaderboard ?? [],
          name: Strings.statisticsFilterMonth,
        );
}

class StatisticsSemester extends StatisticsSuccess {
  StatisticsSemester({List<LeaderboardUser>? leaderboard})
      : super(
          filterBy: StatisticsFilterCategory.semester,
          preset: 1,
          leaderboard: leaderboard ?? [],
          name: Strings.statisticsFilterSemester,
        );
}

class StatisticsTotal extends StatisticsSuccess {
  StatisticsTotal({List<LeaderboardUser>? leaderboard})
      : super(
          filterBy: StatisticsFilterCategory.total,
          preset: 2,
          leaderboard: leaderboard ?? [],
          name: Strings.statisticsFilterTotal,
        );
}
