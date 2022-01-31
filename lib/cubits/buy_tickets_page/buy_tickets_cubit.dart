import 'package:bloc/bloc.dart';
import 'package:coffeecard/errors/network_exception.dart';
import 'package:coffeecard/generated/api/coffeecard_api.swagger.swagger.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'buy_tickets_state.dart';

class BuyTicketsCubit extends Cubit<BuyTicketsState> {
  BuyTicketsCubit() : super(const BuyTicketsLoading());

  Future<void> getTickets() async {
    try {
      emit(const BuyTicketsLoading());
      await Future.delayed(const Duration(seconds: 1));

      //FIXME: uncomment when data is available
      //final List<ProductDto> tickets = await _productRepository.getProducts();
      final tickets = [
        ProductDto(
          id: 1,
          price: 10,
          numberOfTickets: 10,
          name: 'Test Coffee',
          description: 'This is a test',
        )
      ];

      emit(BuyTicketsLoaded(tickets));
    } on NetworkException catch (e) {
      emit(BuyTicketsError(e.message));
    }
  }
}
