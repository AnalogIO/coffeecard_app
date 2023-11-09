import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/core/extensions/either_extensions.dart';
import 'package:coffeecard/features/product/data/datasources/product_remote_data_source.dart';
import 'package:coffeecard/features/product/domain/entities/purchasable_products.dart';
import 'package:fpdart/fpdart.dart';

class GetAllProducts {
  final ProductRemoteDataSource remoteDataSource;

  const GetAllProducts({required this.remoteDataSource});

  Future<Either<Failure, PurchasableProducts>> call() async {
    return remoteDataSource.getProducts().bindFuture((products) {
      return (
        clipCards: products.where((p) => p.amount > 1),
        singleDrinks: products.where((p) => p.amount == 1),
        perks: products.where((p) => p.isPerk),
      );
    });
  }
}
