import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/data/repositories/v1/statistics_repository.dart';
import 'package:coffeecard/models/receipts/receipt.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'statistics_state.dart';

class StatisticsCubit extends Cubit<StatisticsState> {
  final StatisticsRepository _repository;

  StatisticsCubit(this._repository) : super(const StatisticsState());

  void filterStatistics(StatisticsFilterCategory filterBy) {}

  void fetchLeaderboards() {
    //FIXME: implement
  }
}
