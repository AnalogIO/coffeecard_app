import 'package:coffeecard/data/repositories/utils/executor.dart';
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
    return executor.execute(
      apiV1.apiV1ProductsGet,
      (dto) => dto.map((e) => Product.fromDTO(e)),
    );
  }
}
