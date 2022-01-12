part of 'buy_tickets_cubit.dart';

abstract class BuyTicketsState {
  const BuyTicketsState();
}

class BuyTicketsLoading extends BuyTicketsState {
  const BuyTicketsLoading();
}

class BuyTicketsLoaded extends BuyTicketsState {
  final List<ProductDto> products;

  const BuyTicketsLoaded(this.products);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BuyTicketsLoaded && listEquals(other.products, products);
  }

  @override
  int get hashCode => products.hashCode;
}

class BuyTicketsError extends BuyTicketsState {
  final String error;
  const BuyTicketsError(this.error);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BuyTicketsError && other.error == error;
  }

  @override
  int get hashCode => error.hashCode;
}
