part of 'statistics_cubit.dart';

enum StatisticsFilterCategory { semester, month, total }

extension DropdownName on StatisticsFilterCategory {
  String get name {
    if (this == StatisticsFilterCategory.semester) {
      return Strings.statisticsFilterSemester;
    }

    if (this == StatisticsFilterCategory.month) {
      return Strings.statisticsFilterMonth;
    }

    if (this == StatisticsFilterCategory.total) {
      return Strings.statisticsFilterTotal;
    }

    throw Exception('Unknown filter category: $this');
  }
}

class StatisticsState extends Equatable {
  final StatisticsFilterCategory filterBy;
  final List<LeaderboardDto> leaderboard;

  StatisticsState({
    this.filterBy = StatisticsFilterCategory.semester,
    List<LeaderboardDto>? leaderboard,
  }) : leaderboard = leaderboard ?? [];

  @override
  List<Object> get props => [filterBy, leaderboard];

  StatisticsState copyWith({
    StatisticsFilterCategory? filterBy,
    List<LeaderboardDto>? leaderboard,
  }) {
    return StatisticsState(
      filterBy: filterBy ?? this.filterBy,
      leaderboard: leaderboard ?? this.leaderboard,
    );
  }
}
