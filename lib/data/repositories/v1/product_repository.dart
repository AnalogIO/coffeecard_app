import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/core/network/executor.dart';
import 'package:coffeecard/generated/api/coffeecard_api.swagger.dart';
import 'package:coffeecard/models/ticket/product.dart';
import 'package:dartz/dartz.dart';

class ProductRepository {
  ProductRepository({
    required this.apiV1,
    required this.executor,
  });

  final CoffeecardApi apiV1;
  final Executor executor;

  Future<Either<ServerFailure, Iterable<Product>>> getProducts() async {
    final result = await executor(
      apiV1.apiV1ProductsGet,
    );

    return result
        .bind((result) => Right(result.map((e) => Product.fromDTO(e))));
  }
}
