import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/generated/api/coffeecard_api.swagger.swagger.dart';
import 'package:coffeecard/models/api/api_error.dart';
import 'package:coffeecard/utils/either.dart';
import 'package:logger/logger.dart';

class ProductRepository {
  final CoffeecardApi _api;
  final Logger _logger;

  ProductRepository(this._api, this._logger);

  Future<Either<ApiError, List<ProductDto>>> getProducts() async {
    final response = await _api.apiV1ProductsGet();

    if (response.isSuccessful) {
      return Right(response.body!);
    } else {
      _logger.e(Strings.formatApiError(response));
      return Left(ApiError(response.error.toString()));
    }
  }
}
