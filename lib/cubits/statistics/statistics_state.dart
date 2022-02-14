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

  int get preset {
    if (this == StatisticsFilterCategory.semester) {
      return 1;
    }

    if (this == StatisticsFilterCategory.month) {
      return 0;
    }

    if (this == StatisticsFilterCategory.total) {
      return 2;
    }

    throw Exception('Unknown filter category: $this');
  }
}

class StatisticsState extends Equatable {
  final StatisticsFilterCategory filterBy;
  final List<LeaderboardDto> leaderboard;
  final User? user;
  final bool isLeaderboardLoading;
  final bool isUserStatsLoading;

  StatisticsState({
    this.filterBy = StatisticsFilterCategory.semester,
    List<LeaderboardDto>? leaderboard,
    this.isLeaderboardLoading = true,
    this.isUserStatsLoading = true,
    this.user, //FIXME: get user from UserCubit when implemented
  }) : leaderboard = leaderboard ?? [];

  @override
  List<Object?> get props =>
      [filterBy, leaderboard, isLeaderboardLoading, user];

  StatisticsState copyWith({
    StatisticsFilterCategory? filterBy,
    List<LeaderboardDto>? leaderboard,
    bool? isLeaderboardLoading,
    bool? isUserStatsLoading,
    User? user,
  }) {
    return StatisticsState(
      filterBy: filterBy ?? this.filterBy,
      leaderboard: leaderboard ?? this.leaderboard,
      isLeaderboardLoading: isLeaderboardLoading ?? this.isLeaderboardLoading,
      isUserStatsLoading: isUserStatsLoading ?? this.isUserStatsLoading,
      user: user ?? this.user,
    );
  }
}
