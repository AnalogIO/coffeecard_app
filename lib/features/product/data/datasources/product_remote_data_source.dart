import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/core/extensions/either_extensions.dart';
import 'package:coffeecard/core/network/network_request_executor.dart';
import 'package:coffeecard/features/product/data/models/product_model.dart';
import 'package:coffeecard/features/product/domain/entities/product.dart';
import 'package:coffeecard/generated/api/coffeecard_api.swagger.dart';
import 'package:fpdart/fpdart.dart';

class ProductRemoteDataSource {
  final CoffeecardApi apiV1;
  final NetworkRequestExecutor executor;

  ProductRemoteDataSource({
    required this.apiV1,
    required this.executor,
  });

  Future<Either<NetworkFailure, Iterable<Product>>> getProducts() async {
    return executor(
      apiV1.apiV1ProductsGet,
    ).bindFuture((result) => result.map((e) => ProductModel.fromDTO(e)));
  }
}
