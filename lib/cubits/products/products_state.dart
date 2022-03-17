part of 'products_cubit.dart';

abstract class ProductsState extends Equatable {
  const ProductsState();
}

class ProductsLoading extends ProductsState {
  const ProductsLoading();

  @override
  List<Object?> get props => [];
}

class ProductsLoaded extends ProductsState {
  const ProductsLoaded(this.ticketProducts, this.singleDrinkProducts);
  final List<Product> ticketProducts;
  final List<Product> singleDrinkProducts;

  @override
  List<Object?> get props => [ticketProducts, singleDrinkProducts];
}

class ProductsError extends ProductsState {
  const ProductsError(this.error);
  final String error;

  @override
  List<Object?> get props => [error];
}
