part of 'statistics_cubit.dart';

enum StatisticsFilterCategory { thisweek }

extension DropdownName on StatisticsFilterCategory {
  String get name {
    if (this == StatisticsFilterCategory.thisweek) {
      return Strings.statisticsFilterThisWeek;
    }
    throw Exception('Unknown filter category: $this');
  }
}

class StatisticsState extends Equatable {
  final StatisticsFilterCategory filterBy;

  const StatisticsState({
    this.filterBy = StatisticsFilterCategory.thisweek,
  });

  @override
  List<Object> get props => [filterBy];

  StatisticsState copyWith({
    StatisticsFilterCategory? filterBy,
    List<Receipt>? receipts,
    List<Receipt>? filteredReceipts,
  }) {
    return StatisticsState(
      filterBy: filterBy ?? this.filterBy,
    );
  }
}
