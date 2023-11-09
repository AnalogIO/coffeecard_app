import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/core/network/network_request_executor.dart';
import 'package:coffeecard/features/product/data/models/product_model.dart';
import 'package:coffeecard/features/product/domain/entities/product.dart';
import 'package:coffeecard/generated/api/coffeecard_api_v2.swagger.dart';
import 'package:fpdart/fpdart.dart';

class ProductRemoteDataSource {
  final CoffeecardApiV2 api;
  final NetworkRequestExecutor executor;

  ProductRemoteDataSource({required this.api, required this.executor});

  Future<Either<NetworkFailure, List<Product>>> getProducts() {
    return executor
        .execute(api.apiV2ProductsGet)
        .mapAll(ProductModel.fromResponse);
  }
}
