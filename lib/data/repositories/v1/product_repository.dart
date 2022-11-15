import 'package:chopper/chopper.dart';
import 'package:coffeecard/errors/request_error.dart';
import 'package:coffeecard/generated/api/coffeecard_api.swagger.dart';
import 'package:coffeecard/models/ticket/product.dart';
import 'package:coffeecard/utils/either.dart';
import 'package:coffeecard/utils/extensions.dart';
import 'package:logger/logger.dart';

class ProductRepository {
  final CoffeecardApi _api;
  final Logger _logger;

  ProductRepository(this._api, this._logger);

  Future<Either<RequestError, Iterable<Product>>> getProducts() async {
    final Response<List<ProductDto>> response;
    try {
      response = await _api.apiV1ProductsGet();
    } catch (e) {
      return Left(ClientNetworkError());
    }

    if (response.isSuccessful) {
      return Right(response.body!.map((dto) => Product.fromDTO(dto)));
    }
    _logger.e(response.formatError());
    return Left(RequestError(response.error.toString(), response.statusCode));
  }
}
