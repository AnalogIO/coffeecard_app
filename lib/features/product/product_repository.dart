import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/core/network/network_request_executor.dart';
import 'package:coffeecard/features/product/product_model.dart';
import 'package:coffeecard/generated/api/coffeecard_api_v2.swagger.dart';
import 'package:collection/collection.dart';
import 'package:fpdart/fpdart.dart';

/// Repository for fetching products.
///
/// The repository caches all products fetched from the API.
class ProductRepository {
  ProductRepository({required this.api, required this.executor});

  final CoffeecardApiV2 api;
  final NetworkRequestExecutor executor;

  final _cache = <Product>{};

  /// Returns a list of all products.
  TaskEither<Failure, Iterable<Product>> getProducts() {
    return _getAllFromCache().orElse((_) => _getAllFromApi());
  }

  /// Returns the product with the given [productId].
  TaskEither<Failure, Product> getProduct(int productId) {
    return _getFromCache(productId).orElse((_) => _getFromApi(productId));
  }

  TaskEither<Failure, Unit> _cacheAll(Iterable<Product> products) {
    _cache.addAll(products);
    return TaskEither.of(unit);
  }

  TaskEither<Failure, Unit> _cacheProduct(Product product) =>
      _cacheAll([product]);

  TaskEither<Failure, Iterable<Product>> _getAllFromCache() {
    return TaskEither.fromPredicate(
      _cache,
      (cache) => cache.isNotEmpty,
      (_) => const LocalStorageFailure('No products in cache'),
    );
  }

  TaskEither<Failure, Product> _getFromCache(int productId) {
    return TaskEither.fromNullable(
      _cache.firstWhereOrNull((product) => product.id == productId),
      () => LocalStorageFailure('Product with id $productId not in cache'),
    );
  }

  TaskEither<Failure, Iterable<Product>> _getAllFromApi() {
    return executor
        .executeAsTask(api.apiV2ProductsGet)
        .map((products) => products.map(Product.fromResponse))
        .chainFirst(_cacheAll);
  }

  TaskEither<Failure, Product> _getFromApi(int productId) {
    return executor
        .executeAsTask(() => api.apiV2ProductsIdGet(id: productId))
        .map(Product.fromResponse)
        .chainFirst(_cacheProduct);
  }
}
