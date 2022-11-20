part of 'statistics_cubit.dart';

enum LeaderboardFilter { semester, month, total }

abstract class StatisticsState extends Equatable {
  const StatisticsState({required this.filter});
  final LeaderboardFilter filter;

  @override
  List<Object?> get props => [filter];
}

class StatisticsLoading extends StatisticsState {
  const StatisticsLoading({required super.filter});
}

class StatisticsLoaded extends StatisticsState {
  const StatisticsLoaded(this.leaderboard, {required super.filter});
  final List<LeaderboardUser> leaderboard;

  @override
  List<Object?> get props => [filter, ...leaderboard];
}

class StatisticsError extends StatisticsState {
  const StatisticsError(this.errorMessage, {required super.filter});
  final String errorMessage;

  @override
  List<Object?> get props => [filter, errorMessage];
}
