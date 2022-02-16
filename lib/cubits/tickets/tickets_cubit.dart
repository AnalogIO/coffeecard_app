import 'package:coffeecard/errors/network_exception.dart';
import 'package:coffeecard/generated/api/coffeecard_api.swagger.swagger.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'tickets_state.dart';

class TicketsCubit extends Cubit<TicketsState> {
  //final TicketRepository _ticketController = sl.get<TicketRepository>();

  TicketsCubit() : super(const TicketsLoading());

  Future<void> getTickets() async {
    try {
      emit(const TicketsLoading());
      await Future.delayed(const Duration(seconds: 1));
      //FIXME: uncomment once data is available
      //final List<TicketDto> tickets = await _ticketController.getUserTickets();
      final tickets = [TicketDto()];
      emit(TicketsLoaded(tickets));
    } on NetworkException catch (e) {
      emit(TicketsError(e.message));
    }
  }
}
