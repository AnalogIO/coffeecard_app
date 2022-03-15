import 'package:bloc/bloc.dart';
import 'package:coffeecard/data/repositories/v1/product_repository.dart';
import 'package:coffeecard/models/ticket/product.dart';
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

    if (response.isRight) {
      emit(BuyTicketsLoaded(response.right));
    } else {
      emit(BuyTicketsError(response.left.errorMessage));
    }
  }
}
