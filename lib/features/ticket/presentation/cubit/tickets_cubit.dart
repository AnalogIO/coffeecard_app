import 'package:coffeecard/features/receipt/domain/entities/receipt.dart';
import 'package:coffeecard/features/ticket/domain/entities/ticket.dart';
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
    return refreshTickets();
  }

  Future<void> useTicket(int productId, int menuItemId) async {
    if (state is! TicketsLoaded) return;

    final tickets = (state as TicketsLoaded).tickets;

    emit(TicketUsing(tickets: tickets));

    await consumeTicket
        .call(productId: productId, menuItemId: menuItemId)
        .match(
          (failure) =>
              TicketsUseError(message: failure.reason, tickets: tickets),
          (receipt) => TicketUsed(receipt: receipt, tickets: tickets),
        )
        .map(emit)
        .run();

    return refreshTickets();
  }

  Future<void> refreshTickets() => loadTickets()
      .match(
        (failure) => TicketsLoadError(message: failure.reason),
        (tickets) => TicketsLoaded(tickets: tickets),
      )
      .map(emit)
      .run();
}
