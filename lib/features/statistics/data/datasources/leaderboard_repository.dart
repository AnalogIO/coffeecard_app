import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/core/network/network_request_executor.dart';
import 'package:coffeecard/features/statistics/presentation/cubit/statistics_cubit.dart';
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
  final NetworkRequestExecutor executor;

  Future<Either<NetworkFailure, List<LeaderboardUser>>> getLeaderboard(
    LeaderboardFilter category,
  ) async {
    final result = await executor(
      () => apiV2.apiV2LeaderboardTopGet(preset: category.label, top: 10),
    );

    return result.map((result) => result.map(LeaderboardUser.fromDTO).toList());
  }

  Future<Either<NetworkFailure, LeaderboardUser>> getLeaderboardUser(
    LeaderboardFilter category,
  ) async {
    final result = await executor(
      () => apiV2.apiV2LeaderboardGet(preset: category.label),
    );

    return result.map(LeaderboardUser.fromDTO);
  }
}
