import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/core/extensions/either_extensions.dart';
import 'package:coffeecard/core/usecases/usecase.dart';
import 'package:coffeecard/features/product/data/datasources/product_remote_data_source.dart';
import 'package:coffeecard/features/product/domain/entities/product.dart';
import 'package:fpdart/fpdart.dart';

class GetAllProducts
    implements UseCase<(Iterable<Product>, Iterable<Product>), NoParams> {
  final ProductRemoteDataSource remoteDataSource;

  GetAllProducts({required this.remoteDataSource});

  @override
  Future<Either<Failure, (List<Product>, List<Product>)>> call(
    NoParams params,
  ) async {
    return remoteDataSource.getProducts().bindFuture((products) {
      final ticketProducts = products.where((p) => p.amount > 1).toList();
      final singleDrinkProducts = products.where((p) => p.amount == 1).toList();

      return (ticketProducts, singleDrinkProducts);
    });
  }
}
