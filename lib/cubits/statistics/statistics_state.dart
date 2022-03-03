part of 'statistics_cubit.dart';

enum StatisticsFilterCategory { semester, month, total }

abstract class StatisticsState extends Equatable {
  const StatisticsState();

  @override
  List<Object?> get props => throw UnimplementedError;
}

class StatisticsInitial extends StatisticsState {}

class StatisticsLoading extends StatisticsState {
  const StatisticsLoading({required this.filterBy});
  final StatisticsFilterCategory filterBy;

  @override
  List<Object?> get props => [filterBy];
}

class StatisticsLoaded extends StatisticsState {
  const StatisticsLoaded({
    required this.filterBy,
    required this.leaderboard,
  });
  final StatisticsFilterCategory filterBy;
  final List<LeaderboardUser> leaderboard;

  @override
  List<Object?> get props => [filterBy, ...leaderboard];
}

class StatisticsFailure extends StatisticsState {
  const StatisticsFailure({required this.errorMessage});
  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage];
}
