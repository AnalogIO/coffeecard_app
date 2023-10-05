import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/core/extensions/either_extensions.dart';
import 'package:coffeecard/features/product/data/datasources/product_remote_data_source.dart';
import 'package:coffeecard/features/product/domain/entities/product.dart';
import 'package:fpdart/fpdart.dart';

// We ignore this warning because we want to use a typedef for readability.
// ignore: avoid_private_typedef_functions
typedef _AllProducts = (
  Iterable<Product> clipCards,
  Iterable<Product> singleDrinks,
  Iterable<Product> perks,
);

class GetAllProducts {
  final ProductRemoteDataSource remoteDataSource;

  const GetAllProducts({required this.remoteDataSource});

  Future<Either<Failure, _AllProducts>> call() async {
    return remoteDataSource.getProducts().bindFuture((products) {
      final ticketProducts = products.where((p) => p.amount > 1);
      final singleDrinkProducts = products.where((p) => p.amount == 1);
      final perks = products.where((p) => p.isPerk);

      return (ticketProducts, singleDrinkProducts, perks);
    });
  }
}
