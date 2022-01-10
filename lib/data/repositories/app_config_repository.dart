import 'package:coffeecard/generated/api/coffeecard_api.swagger.swagger.dart';
import 'package:coffeecard/models/api/api_error.dart';
import 'package:logger/logger.dart';

class AppConfigRepository {
  final CoffeecardApi _api;
  final Logger _logger;

  AppConfigRepository(this._api, this._logger);

  Future<AppConfigDto> getAppConfig() async {
    final response = await _api.apiV1AppConfigGet();

    if (response.isSuccessful) {
      return response.body!;
    } else {
      _logger.e('API Error ${response.statusCode} ${response.error}');
      throw ApiError(response.error.toString());
    }
  }
}
