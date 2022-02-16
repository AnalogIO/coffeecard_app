part of 'tickets_cubit.dart';

abstract class TicketsState extends Equatable {
  const TicketsState();
}

class TicketsLoading extends TicketsState {
  const TicketsLoading();

  @override
  List<Object?> get props => [];
}

class TicketsLoaded extends TicketsState {
  final List<TicketDto> tickets;

  const TicketsLoaded(this.tickets);

  @override
  List<Object?> get props => tickets;
}

class TicketsError extends TicketsState {
  final String message;
  const TicketsError(this.message);

  @override
  List<Object?> get props => [message];
}
