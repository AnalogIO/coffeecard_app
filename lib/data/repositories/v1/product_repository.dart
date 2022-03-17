import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/generated/api/coffeecard_api.swagger.swagger.dart';
import 'package:coffeecard/models/api/api_error.dart';
import 'package:coffeecard/models/ticket/product.dart';
import 'package:coffeecard/utils/either.dart';
import 'package:logger/logger.dart';

class ProductRepository {
  final CoffeecardApi _api;
  final Logger _logger;

  /// All products retrieved from the API.
  Iterable<Product>? _productsCache;

  ProductRepository(this._api, this._logger);

  Future<Either<ApiError, List<Product>>> _getProducts({
    required bool Function(Product) filter,
  }) async {
    final productsCache = _productsCache;
    if (productsCache != null) {
      return Right(productsCache.where(filter).toList());
    }

    final response = await _api.apiV1ProductsGet();

    if (response.isSuccessful) {
      final products = response.body!.map((dto) => Product.fromDTO(dto));
      _productsCache = products;
      return Right(products.where(filter).toList());
    }

    _logger.e(Strings.formatApiError(response));
    return Left(ApiError(response.error.toString()));
  }

  /// Get purchaseable ticket (coffee card) products.
  Future<Either<ApiError, List<Product>>> getTicketProducts() async {
    return _getProducts(filter: (product) => product.amount > 1);
  }

  /// Get purchaseable single drink products.
  Future<Either<ApiError, List<Product>>> getSingleDrinkProducts() async {
    return _getProducts(filter: (product) => product.amount == 1);
  }
}
