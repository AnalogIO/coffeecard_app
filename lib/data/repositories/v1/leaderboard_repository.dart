import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/generated/api/coffeecard_api.swagger.swagger.dart';
import 'package:coffeecard/models/api/api_error.dart';
import 'package:coffeecard/models/leaderboard_user.dart';
import 'package:coffeecard/utils/either.dart';
import 'package:logger/logger.dart';

class LeaderboardRepository {
  final CoffeecardApi _api;
  final Logger _logger;

  LeaderboardRepository(this._api, this._logger);

  Future<Either<ApiError, List<LeaderboardUser>>> getLeaderboard(
    int? preset, {
    int? top,
  }) async {
    final response = await _api.apiV1LeaderboardGet(preset: preset, top: top);

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
