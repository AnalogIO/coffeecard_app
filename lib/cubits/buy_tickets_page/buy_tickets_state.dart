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
  const BuyTicketsLoaded(this.products);
  final List<Product> products;

  @override
  List<Object?> get props => products;
}

class BuyTicketsError extends BuyTicketsState {
  const BuyTicketsError(this.error);
  final String error;

  @override
  List<Object?> get props => [error];
}
