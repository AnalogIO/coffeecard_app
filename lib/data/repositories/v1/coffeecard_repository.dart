import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/generated/api/coffeecard_api.swagger.dart';
import 'package:coffeecard/models/api/api_error.dart';
import 'package:coffeecard/utils/either.dart';
import 'package:logger/logger.dart';

class CoffeeCardRepository {
  final CoffeecardApi _api;
  final Logger _logger;

  CoffeeCardRepository(this._api, this._logger);

  Future<Either<ApiError, CoffeeCardDto>> getCoffeeCards() async {
    final response = await _api.apiV1CoffeeCardsGet();

    if (response.isSuccessful) {
      return Right(response.body!);
    } else {
      _logger.e(Strings.formatApiError(response));
      return Left(ApiError(response.error.toString()));
    }
  }
}
