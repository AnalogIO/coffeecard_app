import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/core/extensions/either_extensions.dart';
import 'package:coffeecard/core/usecases/usecase.dart';
import 'package:coffeecard/features/product/data/datasources/product_remote_data_source.dart';
import 'package:coffeecard/features/product/domain/entities/product.dart';
import 'package:fpdart/fpdart.dart';

typedef _AllProducts = (
  Iterable<Product> clipCards,
  Iterable<Product> singleDrinks,
  Iterable<Product> perks,
);

class GetAllProducts implements UseCase<_AllProducts, NoParams> {
  final ProductRemoteDataSource remoteDataSource;

  const GetAllProducts({required this.remoteDataSource});

  @override
  Future<Either<Failure, _AllProducts>> call(NoParams params) async {
    return remoteDataSource.getProducts().bindFuture((products) {
      final ticketProducts = products.where((p) => p.amount > 1);
      final singleDrinkProducts = products.where((p) => p.amount == 1);
      final perks = products.where((p) => p.isPerk);

      return (ticketProducts, singleDrinkProducts, perks);
    });
  }
}
