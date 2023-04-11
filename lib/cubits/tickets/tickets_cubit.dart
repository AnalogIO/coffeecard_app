import 'package:coffeecard/data/repositories/v1/ticket_repository.dart';
import 'package:coffeecard/models/receipts/receipt.dart';
import 'package:coffeecard/models/ticket/ticket_count.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'tickets_state.dart';

class TicketsCubit extends Cubit<TicketsState> {
  TicketsCubit(this.ticketRepository) : super(const TicketsLoading());

  final TicketRepository ticketRepository;

  Future<void> getTickets() async {
    emit(const TicketsLoading());

    refreshTickets();
  }

  Future<void> useTicket(int productId) async {
    if (state is! TicketsLoaded) return;

    final st = state as TicketsLoaded;

    emit(TicketUsing(st.tickets));

    final either = await ticketRepository.useTicket(productId);

    either.fold(
      (error) => emit(TicketsUseError(error.reason)),
      (receipt) => emit(TicketUsed(receipt, st.tickets)),
    );

    refreshTickets();
  }

  Future<void> refreshTickets() async {
    final either = await ticketRepository.getUserTickets();

    either.fold(
      (error) => emit(TicketsLoadError(error.reason)),
      (tickets) => emit(TicketsLoaded(tickets)),
    );
  }
}
