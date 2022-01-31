part of 'buy_one_drink_cubit.dart';

abstract class BuyOneDrinkState extends Equatable {
  const BuyOneDrinkState();
}

class BuyOneDrinkLoading extends BuyOneDrinkState {
  const BuyOneDrinkLoading();

  @override
  List<Object?> get props => [];
}

class BuyOneDrinkLoaded extends BuyOneDrinkState {
  //FIXME: should be DTO from database, fetch when data is available
  final List<SingleCoffeeCard> products;

  const BuyOneDrinkLoaded(this.products);

  @override
  List<Object?> get props => products;
}

class BuyOneDrinkError extends BuyOneDrinkState {
  final String error;
  const BuyOneDrinkError(this.error);

  @override
  List<Object?> get props => [error];
}
