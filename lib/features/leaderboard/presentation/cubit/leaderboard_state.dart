part of 'leaderboard_cubit.dart';

enum LeaderboardFilter { semester, month, total }

sealed class LeaderboardState extends Equatable {
  const LeaderboardState({required this.filter});
  final LeaderboardFilter filter;

  @override
  List<Object?> get props => [filter];
}

class LeaderboardLoading extends LeaderboardState {
  const LeaderboardLoading({required super.filter});
}

class LeaderboardLoaded extends LeaderboardState {
  const LeaderboardLoaded(this.leaderboard, {required super.filter});
  final List<LeaderboardUser> leaderboard;

  @override
  List<Object?> get props => [filter, leaderboard];
}

class LeaderboardError extends LeaderboardState {
  const LeaderboardError(this.errorMessage, {required super.filter});
  final String errorMessage;

  @override
  List<Object?> get props => [filter, errorMessage];
}
