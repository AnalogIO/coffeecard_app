import 'package:coffeecard/generated/api/coffeecard_api.swagger.swagger.dart';
import 'package:coffeecard/models/api/api_error.dart';
import 'package:coffeecard/utils/either.dart';
import 'package:logger/logger.dart';

class LeaderboardRepository {
  final CoffeecardApi _api;
  final Logger _logger;

  LeaderboardRepository(this._api, this._logger);

  Future<Either<ApiError, List<LeaderboardDto>>> getLeaderboard(
      int? preset, int? top,) async {
    final response = await _api.apiV1LeaderboardGet(preset: preset, top: top);

    if (response.isSuccessful) {
      return Right(response.body!);
    } else {
      _logger.e('API Error ${response.statusCode} ${response.error}');
      return Left(ApiError(response.error.toString()));
    }
  }
}
