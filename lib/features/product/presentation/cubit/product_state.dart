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
  final Iterable<Product> clipCards;
  final Iterable<Product> singleDrinks;
  final Iterable<Product> perks;

  const ProductsLoaded({
    required this.clipCards,
    required this.singleDrinks,
    required this.perks,
  });

  @override
  List<Object?> get props => [clipCards, singleDrinks, perks];
}

class ProductsError extends ProductState {
  final String error;

  const ProductsError(this.error);

  @override
  List<Object?> get props => [error];
}
