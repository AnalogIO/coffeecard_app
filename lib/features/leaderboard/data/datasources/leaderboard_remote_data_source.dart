import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/core/extensions/either_extensions.dart';
import 'package:coffeecard/core/network/network_request_executor.dart';
import 'package:coffeecard/features/leaderboard/data/models/leaderboard_user_model.dart';
import 'package:coffeecard/features/leaderboard/domain/entities/leaderboard_user.dart';
import 'package:coffeecard/features/leaderboard/presentation/cubit/leaderboard_cubit.dart';
import 'package:coffeecard/generated/api/coffeecard_api_v2.swagger.dart';
import 'package:fpdart/fpdart.dart';

extension _FilterCategoryToPresetString on LeaderboardFilter {
  String get label => switch (this) {
        LeaderboardFilter.semester => 'Semester',
        LeaderboardFilter.month => 'Month',
        LeaderboardFilter.total => 'Total',
      };
}

class LeaderboardRemoteDataSource {
  final CoffeecardApiV2 apiV2;
  final NetworkRequestExecutor executor;

  LeaderboardRemoteDataSource({
    required this.apiV2,
    required this.executor,
  });

  Future<Either<NetworkFailure, List<LeaderboardUser>>> getLeaderboard(
    LeaderboardFilter category,
    int top,
  ) async {
    return executor(
      () => apiV2.apiV2LeaderboardTopGet(preset: category.label, top: top),
    ).bindFuture(
      (result) => result.map(LeaderboardUserModel.fromDTO).toList(),
    );
  }

  Future<Either<NetworkFailure, LeaderboardUser>> getLeaderboardUser(
    LeaderboardFilter category,
  ) async {
    return executor(
      () => apiV2.apiV2LeaderboardGet(preset: category.label),
    ).bindFuture(LeaderboardUserModel.fromDTO);
  }
}
