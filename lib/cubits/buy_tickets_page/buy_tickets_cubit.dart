import 'package:bloc/bloc.dart';
import 'package:coffeecard/data/repositories/v1/product_repository.dart';
import 'package:coffeecard/models/ticket/product.dart';
import 'package:coffeecard/utils/either.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'buy_tickets_state.dart';

enum FilterCategory { clipCards, singleTickets }

class BuyTicketsCubit extends Cubit<BuyTicketsState> {
  final ProductRepository _repository;

  BuyTicketsCubit(this._repository) : super(const BuyTicketsLoading());

  Future<void> getTickets() async {
    emit(const BuyTicketsLoading());
    final response = await _repository.getProducts();

    if (response is Left) {
      emit(BuyTicketsError(response.left.errorMessage));
    } else {
      final List<Product> tickets = response.right;
      emit(BuyTicketsLoaded(tickets));
    }
  }
}
