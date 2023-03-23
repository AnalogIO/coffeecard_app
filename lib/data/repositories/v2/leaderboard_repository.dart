import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/core/network/executor.dart';
import 'package:coffeecard/cubits/statistics/statistics_cubit.dart';
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

  Future<Either<ServerFailure, List<LeaderboardUser>>> getLeaderboard(
    LeaderboardFilter category,
  ) async {
    final result = await executor(
      () => apiV2.apiV2LeaderboardTopGet(preset: category.label, top: 10),
    );

    return result.map((result) => result.map(LeaderboardUser.fromDTO).toList());
  }

  Future<Either<ServerFailure, LeaderboardUser>> getLeaderboardUser(
    LeaderboardFilter category,
  ) async {
    final result = await executor(
      () => apiV2.apiV2LeaderboardGet(preset: category.label),
    );

    return result.map((result) => LeaderboardUser.fromDTO(result));
  }
}
