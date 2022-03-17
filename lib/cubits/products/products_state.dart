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
  const ProductsLoaded(this.products);
  final List<Product> products;

  @override
  List<Object?> get props => products;
}

class ProductsError extends ProductsState {
  const ProductsError(this.error);
  final String error;

  @override
  List<Object?> get props => [error];
}
