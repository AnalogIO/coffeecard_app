import 'package:chopper/chopper.dart';
import 'package:coffeecard/errors/request_error.dart';
import 'package:coffeecard/generated/api/coffeecard_api.swagger.dart';
import 'package:coffeecard/utils/either.dart';
import 'package:coffeecard/utils/extensions.dart';
import 'package:logger/logger.dart';

class CoffeeCardRepository {
  final CoffeecardApi _api;
  final Logger _logger;

  CoffeeCardRepository(this._api, this._logger);

  Future<Either<RequestError, CoffeeCardDto>> getCoffeeCards() async {
    final Response<CoffeeCardDto> response;
    try {
      response = await _api.apiV1CoffeeCardsGet();
    } catch (e) {
      return Left(ClientNetworkError());
    }

    if (response.isSuccessful) {
      return Right(response.body!);
    }
    _logger.e(response.formatError());
    return Left(RequestError(response.error.toString(), response.statusCode));
  }
}
