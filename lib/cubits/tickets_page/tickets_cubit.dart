import 'package:coffeecard/data/repositories/v1/ticket_repository.dart';
import 'package:coffeecard/generated/api/coffeecard_api.swagger.swagger.dart';
import 'package:coffeecard/models/ticket/product_count.dart';
import 'package:coffeecard/utils/either.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'tickets_state.dart';

class TicketsCubit extends Cubit<TicketsState> {
  final TicketRepository _ticketRepository;

  TicketsCubit(this._ticketRepository) : super(const TicketsLoading());

  Future<void> getTickets() async {
    emit(const TicketsLoading());
    final response = await _ticketRepository.getUserTickets();
    if (response is Right) {
      final List<TicketDto> tickets = response.right;
      final productCount = tickets
          //TODO consider if this conversion makes better sense to have in the repository instead
          //Groups all products by their id, and returns the amount of products for each id, and their name
          .groupListsBy((t) => t.productName)
          .entries
          .map((e) => ProductCount(e.value.length, e.key!))
          .toList();
      emit(TicketsLoaded(productCount));
    } else {
      emit(TicketsError(response.left.errorMessage));
    }
  }
}
