import 'package:coffeecard/features/receipt/domain/entities/receipt.dart';
import 'package:coffeecard/features/ticket/domain/entities/ticket_count.dart';
import 'package:coffeecard/features/ticket/domain/usecases/consume_ticket.dart';
import 'package:coffeecard/features/ticket/domain/usecases/load_tickets.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'tickets_state.dart';

class TicketsCubit extends Cubit<TicketsState> {
  final LoadTickets loadTickets;
  final ConsumeTicket consumeTicket;

  TicketsCubit({
    required this.loadTickets,
    required this.consumeTicket,
  }) : super(const TicketsLoading());

  Future<void> getTickets() async {
    emit(const TicketsLoading());
    refreshTickets();
  }

  Future<void> useTicket(int productId) async {
    if (state is! TicketsLoaded) return;

    final st = state as TicketsLoaded;

    emit(TicketUsing(tickets: st.tickets));

    final either = await consumeTicket(productId: productId);

    emit(
      either.fold(
        (error) => TicketsUseError(message: error.reason),
        (receipt) => TicketUsed(receipt: receipt, tickets: st.tickets),
      ),
    );

    refreshTickets();
  }

  Future<void> refreshTickets() async {
    final either = await loadTickets();

    emit(
      either.fold(
        (error) => TicketsLoadError(message: error.reason),
        (tickets) => TicketsLoaded(tickets: tickets),
      ),
    );
  }
}
