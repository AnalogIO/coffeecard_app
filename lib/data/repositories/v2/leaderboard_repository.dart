import 'package:coffeecard/cubits/statistics/statistics_cubit.dart';
import 'package:coffeecard/data/repositories/utils/executor.dart';
import 'package:coffeecard/data/repositories/utils/request_types.dart';
import 'package:coffeecard/generated/api/coffeecard_api_v2.swagger.dart';
import 'package:coffeecard/models/leaderboard/leaderboard_user.dart';
import 'package:dartz/dartz.dart';

extension _FilterCategoryToPresetString on LeaderboardFilter {
  String get label {
    switch (this) {
      case LeaderboardFilter.semester:
        return 'Semester';
      case LeaderboardFilter.month:
        return 'Month';
      case LeaderboardFilter.total:
        return 'Total';
    }
  }
}

class LeaderboardRepository {
  LeaderboardRepository({
    required this.apiV2,
    required this.executor,
  });

  final CoffeecardApiV2 apiV2;
  final Executor executor;

  Future<Either<RequestFailure, List<LeaderboardUser>>> getLeaderboard(
    LeaderboardFilter category,
  ) async {
    return executor.execute(
      () => apiV2.apiV2LeaderboardTopGet(preset: category.label, top: 10),
      (dtoList) => dtoList.map(LeaderboardUser.fromDTO).toList(),
    );
  }

  Future<Either<RequestFailure, LeaderboardUser>> getLeaderboardUser(
    LeaderboardFilter category,
  ) async {
    return executor.execute(
      () => apiV2.apiV2LeaderboardGet(preset: category.label),
      LeaderboardUser.fromDTO,
    );
  }
}
