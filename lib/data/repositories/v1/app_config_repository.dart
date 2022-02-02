import 'package:coffeecard/generated/api/coffeecard_api_v2.swagger.swagger.dart';
import 'package:coffeecard/models/api/api_error.dart';
import 'package:coffeecard/utils/either.dart';
import 'package:logger/logger.dart';

class AppConfigRepository {
  final CoffeecardApiV2 _api;
  final Logger _logger;

  AppConfigRepository(this._api, this._logger);
  
  Future<Either<ApiError, AppConfigDto>> getAppConfig() async {
    final response = await _api.apiV1AppConfigGet();

    if (response.isSuccessful) {
      return Right(response.body!);
    } else {
      _logger.e('API Error ${response.statusCode} ${response.error}');
      return Left(ApiError(response.error.toString()));
    }
  }
}
