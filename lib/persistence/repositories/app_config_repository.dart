import 'package:coffeecard/generated/api/coffeecard_api.swagger.swagger.dart';
import 'package:coffeecard/models/http/api_error.dart';
import 'package:coffeecard/persistence/api/coffee_card_api_constants.dart';
import 'package:logger/logger.dart';

class AppConfigRepository {
  final CoffeecardApi _api;
  final Logger _logger;

  AppConfigRepository(this._api, this._logger);

  Future<AppConfigDto> getAppConfig() async {
    final response = await _api.apiVVersionAppConfigGet(
      version: CoffeeCardApiConstants.apiVersion,
    );

    if (response.isSuccessful) {
      return response.body!;
    } else {
      _logger.e('API Error ${response.statusCode} ${response.error}');
      throw ApiError(response.error.toString());
    }
  }
}
