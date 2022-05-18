import 'package:coffeecard/generated/api/coffeecard_api.swagger.dart';
import 'package:coffeecard/models/api/api_error.dart';
import 'package:coffeecard/models/ticket/product.dart';
import 'package:coffeecard/utils/either.dart';
import 'package:coffeecard/utils/extensions.dart';
import 'package:logger/logger.dart';

class ProductRepository {
  final CoffeecardApi _api;
  final Logger _logger;

  ProductRepository(this._api, this._logger);

  Future<Either<ApiError, Iterable<Product>>> getProducts() async {
    final response = await _api.apiV1ProductsGet();
    if (response.isSuccessful) {
      return Right(response.body!.map((dto) => Product.fromDTO(dto)));
    }

    _logger.e(response.formatError());
    return Left(ApiError(response.error.toString()));
  }
}
