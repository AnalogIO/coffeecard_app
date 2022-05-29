import 'package:coffeecard/data/repositories/v1/ticket_repository.dart';
import 'package:coffeecard/models/receipts/receipt.dart';
import 'package:coffeecard/models/ticket/ticket_count.dart';
import 'package:coffeecard/utils/either.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'tickets_state.dart';

class TicketsCubit extends Cubit<TicketsState> {
  final TicketRepository _ticketRepository;

  TicketsCubit(this._ticketRepository) : super(const TicketsLoading());

  Future<void> getTickets() async {
    emit(const TicketsLoading());
    refreshTickets();
  }

  Future<void> useTicket(int productId) async {
    if (state is TicketsLoaded) {
      final previousState = state as TicketsLoaded;
      emit(TicketUsing(previousState.tickets));
      final response = await _ticketRepository.useTicket(productId);
      if (response is Right) {
        emit(TicketUsed(response.right, previousState.tickets));
        // Refresh tickets, so the user sees the right count
        refreshTickets();
      } else {
        emit(TicketsError(response.left.message));
      }
    }
  }

  Future<void> refreshTickets() async {
    final response = await _ticketRepository.getUserTickets();
    if (response is Right) {
      emit(TicketsLoaded(response.right));
    } else {
      emit(TicketsError(response.left.message));
    }
  }
}
