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

  const ProductsLoaded(this.products);

  @override
  List<Object?> get props => [products];
}

class ProductsError extends ProductState {
  final String error;

  const ProductsError(this.error);
  ProductsError.fromFailure(Failure failure) : error = failure.reason;

  @override
  List<Object?> get props => [error];
}
