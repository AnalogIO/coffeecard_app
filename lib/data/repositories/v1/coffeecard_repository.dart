import 'package:coffeecard/generated/api/coffeecard_api.swagger.swagger.dart';
import 'package:coffeecard/models/api/api_error.dart';
import 'package:logger/logger.dart';

class CoffeeCardRepository {
  final CoffeecardApi _api;
  final Logger _logger;

  CoffeeCardRepository(this._api, this._logger);

  Future<CoffeeCardDto> getCoffeeCards() async {
    final response = await _api.apiV1CoffeeCardsGet();

    if (response.isSuccessful) {
      return response.body!;
    } else {
      _logger.e('API Error ${response.statusCode} ${response.error}');
      throw ApiError(response.error.toString());
    }
  }
}
