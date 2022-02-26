import 'package:coffeecard/data/repositories/v1/ticket_repository.dart';
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
    final response = await _ticketRepository.getUserTickets();
    if (response is Right) {
      emit(TicketsLoaded(response.right));
    } else {
      emit(TicketsError(response.left.errorMessage));
    }
  }
}
