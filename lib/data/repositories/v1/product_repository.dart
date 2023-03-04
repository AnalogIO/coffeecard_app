import 'package:coffeecard/core/errors/exceptions.dart';
import 'package:coffeecard/core/network/executor.dart';
import 'package:coffeecard/data/repositories/utils/request_types.dart';
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

  Future<Either<RequestFailure, Iterable<Product>>> getProducts() async {
    try {
      final result = await executor(
        apiV1.apiV1ProductsGet,
      );

      return Right(result!.map((e) => Product.fromDTO(e)));
    } on ServerException catch (e) {
      return Left(RequestFailure(e.error));
    }
  }
}
