part of 'statistics_cubit.dart';

enum StatisticsFilterCategory { semester, month, total }

abstract class StatisticsState extends Equatable {
  const StatisticsState();

  @override
  List<Object?> get props => [];
}

class StatisticsInitial extends StatisticsState {}

abstract class StatisticsStateWithFilterCategory extends StatisticsState {
  const StatisticsStateWithFilterCategory(this.filterBy);
  final StatisticsFilterCategory filterBy;

  @override
  List<Object?> get props => [filterBy];
}

class StatisticsLoading extends StatisticsStateWithFilterCategory {
  const StatisticsLoading({required StatisticsFilterCategory filterBy})
      : super(filterBy);

  @override
  List<Object?> get props => [filterBy];
}

class StatisticsLoaded extends StatisticsStateWithFilterCategory {
  const StatisticsLoaded({
    required this.leaderboard,
    required StatisticsFilterCategory filterBy,
  }) : super(filterBy);

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
