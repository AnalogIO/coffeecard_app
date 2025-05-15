part of 'product_cubit.dart';

sealed class ProductState extends Equatable {
  const ProductState();
}

class ProductsLoading extends ProductState {
  const ProductsLoading();

  @override
  List<Object?> get props => [];
}

class ProductsLoaded extends ProductState {
  final PurchasableProducts products;

  ProductsLoaded(Iterable<Product> products)
      : products = (
          clipCards: products.where((p) => p.amount > 1),
          singleDrinks: products.where((p) => p.amount == 1 && !p.isPerk),
          perks: products.where((p) => p.isPerk),
        );

  @override
  List<Object?> get props => [products];
}

class ProductsError extends ProductState {
  final String error;

  ProductsError(Failure failure) : error = failure.reason;

  @override
  List<Object?> get props => [error];
}
