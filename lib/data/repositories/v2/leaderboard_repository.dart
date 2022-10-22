import 'package:coffeecard/cubits/statistics/statistics_cubit.dart';
import 'package:coffeecard/generated/api/coffeecard_api_v2.swagger.dart';
import 'package:coffeecard/models/api/api_error.dart';
import 'package:coffeecard/models/leaderboard_user.dart';
import 'package:coffeecard/utils/either.dart';
import 'package:coffeecard/utils/extensions.dart';
import 'package:logger/logger.dart';

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
  final CoffeecardApiV2 _api;
  final Logger _logger;

  LeaderboardRepository(this._api, this._logger);

  Future<Either<ApiError, List<LeaderboardUser>>> getLeaderboard(
    LeaderboardFilter category,
  ) async {
    final response =
        await _api.apiV2LeaderboardTopGet(preset: category.label, top: 10);

    if (response.isSuccessful) {
      return Right(
        response.body!
            .map(
              (e) => LeaderboardUser(
                id: e.id!,
                name: e.name!,
                score: e.score!,
                highlight: false,
                rank: e.rank!,
              ),
            )
            .toList(),
      );
    } else {
      _logger.e(response.formatError());
      return Left(ApiError(response.error.toString()));
    }
  }

  Future<Either<ApiError, LeaderboardEntry>> getUserLeaderboardEntry(
    LeaderboardFilter category,
  ) async {
    final response = await _api.apiV2LeaderboardGet(preset: category.label);

    if (response.isSuccessful) {
      return Right(response.body!);
    } else {
      _logger.e(response.formatError());
      return Left(ApiError(response.error.toString()));
    }
  }
}
