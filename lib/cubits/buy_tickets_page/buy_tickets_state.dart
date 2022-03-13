part of 'buy_tickets_cubit.dart';

abstract class BuyTicketsState extends Equatable {
  const BuyTicketsState();
}

class BuyTicketsLoading extends BuyTicketsState {
  const BuyTicketsLoading();

  @override
  List<Object?> get props => [];
}

class BuyTicketsLoaded extends BuyTicketsState {
  final List<Product> products;

  const BuyTicketsLoaded(this.products);

  @override
  List<Object?> get props => products;
}

class BuyTicketsFiltered extends BuyTicketsLoaded {
  final List<Product> filteredProducts;

  const BuyTicketsFiltered(List<Product> products, this.filteredProducts)
      : super(products);

  @override
  List<Object?> get props => [products, filteredProducts];
}

class BuyTicketsError extends BuyTicketsState {
  final String error;
  const BuyTicketsError(this.error);

  @override
  List<Object?> get props => [error];
}
