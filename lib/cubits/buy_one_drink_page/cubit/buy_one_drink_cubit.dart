import 'package:bloc/bloc.dart';
import 'package:coffeecard/errors/network_exception.dart';
import 'package:coffeecard/widgets/components/single_coffee_card.dart';
import 'package:flutter/foundation.dart';

part 'buy_one_drink_state.dart';

class BuyOneDrinkCubit extends Cubit<BuyOneDrinkState> {
  BuyOneDrinkCubit() : super(const BuyOneDrinkLoading());

  Future<void> getTickets() async {
    try {
      emit(const BuyOneDrinkLoading());
      await Future.delayed(const Duration(seconds: 1));

      //FIXME: fetch when data is available
      final tickets = [
        SingleCoffeeCard(
          title: 'Filter coffee',
          options: const {'Per cup': 10},
          price: 80,
          onTap: () {},
        ),
        SingleCoffeeCard(
          title: 'Caffe latte',
          options: const {'Single': 17, 'Double': 20},
          price: 80,
          onTap: () {},
        ),
      ];

      emit(BuyOneDrinkLoaded(tickets));
    } on NetworkException catch (e) {
      emit(BuyOneDrinkError(e.message));
    }
  }
}
