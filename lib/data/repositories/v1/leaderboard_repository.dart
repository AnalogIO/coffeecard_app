import 'package:coffeecard/cubits/statistics/statistics_cubit.dart';
import 'package:coffeecard/generated/api/coffeecard_api.swagger.dart';
import 'package:coffeecard/models/api/api_error.dart';
import 'package:coffeecard/models/leaderboard_user.dart';
import 'package:coffeecard/utils/either.dart';
import 'package:coffeecard/utils/extensions.dart';
import 'package:logger/logger.dart';

extension _FilterCategoryToPresetInteger on LeaderboardFilter {
  int get preset {
    if (this == LeaderboardFilter.month) return 0;
    if (this == LeaderboardFilter.semester) return 1;
    if (this == LeaderboardFilter.total) return 2;
    throw Exception(message: 'Unknown filter category: $this');
  }
}

class LeaderboardRepository {
  final CoffeecardApi _api;
  final Logger _logger;

  LeaderboardRepository(this._api, this._logger);

  Future<Either<ApiError, List<LeaderboardUser>>> getLeaderboard(
    LeaderboardFilter category,
  ) async {
    final response = await _api.apiV1LeaderboardGet(preset: category.preset);

    if (response.isSuccessful) {
      return Right(
        response.body!.map((e) => LeaderboardUser.fromDTO(e)).toList(),
      );
    } else {
      _logger.e(response.formatError());
      return Left(ApiError(response.error.toString()));
    }
  }
}
