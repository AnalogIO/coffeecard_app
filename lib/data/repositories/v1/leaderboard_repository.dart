import 'package:coffeecard/generated/api/coffeecard_api.swagger.swagger.dart';
import 'package:coffeecard/models/api/api_error.dart';
import 'package:coffeecard/utils/either.dart';
import 'package:logger/logger.dart';

class LeaderboardRepository {
  final CoffeecardApi _api;
  final Logger _logger;

  LeaderboardRepository(this._api, this._logger);

  Future<Either<ApiError, List<LeaderboardDto>>> getLeaderboard(
    int? preset,
    int? top,
  ) async {
    final response = await _api.apiV1LeaderboardGet(preset: preset, top: top);

    if (response.isSuccessful) {
      final List<LeaderboardDto> dummyData = [
        LeaderboardDto(name: 'test1', score: 1),
        LeaderboardDto(name: 'test2', score: 2),
        LeaderboardDto(name: 'test3', score: 3),
        LeaderboardDto(name: 'test4', score: 4),
        LeaderboardDto(name: 'test5', score: 5),
      ];

      return Right(dummyData);

      //return Right(response.body!);
    } else {
      _logger.e('API Error ${response.statusCode} ${response.error}');
      return Left(ApiError(response.error.toString()));
    }
  }
}
