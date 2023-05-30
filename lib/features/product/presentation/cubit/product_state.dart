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
  final List<Product> ticketProducts;
  final List<Product> singleDrinkProducts;

  const ProductsLoaded(this.ticketProducts, this.singleDrinkProducts);

  @override
  List<Object?> get props => [ticketProducts, singleDrinkProducts];
}

class ProductsError extends ProductState {
  final String error;

  const ProductsError(this.error);

  @override
  List<Object?> get props => [error];
}
