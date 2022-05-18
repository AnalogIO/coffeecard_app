import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/cubits/statistics/statistics_cubit.dart';
import 'package:coffeecard/generated/api/coffeecard_api.swagger.dart';
import 'package:coffeecard/models/api/api_error.dart';
import 'package:coffeecard/models/leaderboard_user.dart';
import 'package:coffeecard/utils/either.dart';
import 'package:logger/logger.dart';

extension _FilterCategoryToPresetInteger on StatisticsFilterCategory {
  int get preset {
    if (this == StatisticsFilterCategory.month) return 0;
    if (this == StatisticsFilterCategory.semester) return 1;
    if (this == StatisticsFilterCategory.total) return 2;
    throw Exception(message: 'Unknown filter category: $this');
  }
}

class LeaderboardRepository {
  final CoffeecardApi _api;
  final Logger _logger;

  LeaderboardRepository(this._api, this._logger);

  Future<Either<ApiError, List<LeaderboardUser>>> getLeaderboard(
    StatisticsFilterCategory category,
  ) async {
    final response = await _api.apiV1LeaderboardGet(preset: category.preset);

    if (response.isSuccessful) {
      return Right(
        response.body!.map((e) => LeaderboardUser.fromDTO(e)).toList(),
      );
    } else {
      _logger.e(Strings.formatApiError(response));
      return Left(ApiError(response.error.toString()));
    }
  }
}
