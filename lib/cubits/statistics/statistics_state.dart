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

  const StatisticsState({
    this.filterBy = StatisticsFilterCategory.semester,
  });

  @override
  List<Object> get props => [filterBy];

  StatisticsState copyWith({
    StatisticsFilterCategory? filterBy,
  }) {
    return StatisticsState(
      filterBy: filterBy ?? this.filterBy,
    );
  }
}
