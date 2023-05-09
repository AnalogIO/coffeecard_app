import 'package:coffeecard/core/usecases/usecase.dart';
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
    required bool isBarista,
  }) : super(TicketsLoading(isBarista: isBarista));

  Future<void> getTickets() async {
    emit(TicketsLoading(isBarista: state.isBarista));

    refreshTickets();
  }

  void setBaristaMode({required bool baristaMode}) {
    emit(state.copyWith(isBarista: baristaMode));
  }

  Future<void> useTicket(int productId) async {
    if (state is! TicketsLoaded) return;

    final st = state as TicketsLoaded;

    emit(TicketUsing(tickets: st.tickets, isBarista: state.isBarista));

    final either = await consumeTicket(Params(productId: productId));

    either.fold(
      (error) => emit(
        TicketsUseError(
          message: error.reason,
          isBarista: state.isBarista,
        ),
      ),
      (receipt) => emit(
        TicketUsed(
          receipt: receipt,
          tickets: st.tickets,
          isBarista: state.isBarista,
        ),
      ),
    );

    refreshTickets();
  }

  Future<void> refreshTickets() async {
    final either = await loadTickets(NoParams());

    either.fold(
      (error) => emit(
        TicketsLoadError(
          message: error.reason,
          isBarista: state.isBarista,
        ),
      ),
      (tickets) =>
          emit(TicketsLoaded(tickets: tickets, isBarista: state.isBarista)),
    );
  }
}
