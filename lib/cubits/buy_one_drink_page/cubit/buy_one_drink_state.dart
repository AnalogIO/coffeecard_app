part of 'buy_one_drink_cubit.dart';

abstract class BuyOneDrinkState {
  const BuyOneDrinkState();
}

class BuyOneDrinkLoading extends BuyOneDrinkState {
  const BuyOneDrinkLoading();
}

class BuyOneDrinkLoaded extends BuyOneDrinkState {
  //FIXME: should be DTO from database, fetch when data is available
  List<SingleCoffeeCard> products;

  BuyOneDrinkLoaded(this.products);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BuyOneDrinkLoaded && listEquals(other.products, products);
  }

  @override
  int get hashCode => products.hashCode;
}

class BuyOneDrinkError extends BuyOneDrinkState {
  final String error;
  const BuyOneDrinkError(this.error);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BuyOneDrinkError && other.error == error;
  }

  @override
  int get hashCode => error.hashCode;
}
