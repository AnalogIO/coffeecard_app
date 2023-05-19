part of 'tickets_cubit.dart';

sealed class TicketsState extends Equatable {
  const TicketsState();
}

class TicketsLoading extends TicketsState {
  const TicketsLoading();

  @override
  List<Object?> get props => [];
}

class TicketsLoaded extends TicketsState {
  final List<TicketCount> tickets;

  const TicketsLoaded(this.tickets);

  @override
  List<Object?> get props => tickets;
}

class TicketUsing extends TicketsLoaded {
  const TicketUsing(super.tickets);
}

class TicketUsed extends TicketsLoaded {
  final Receipt receipt;

  const TicketUsed(this.receipt, List<TicketCount> tickets) : super(tickets);

  @override
  List<Object?> get props => [receipt];
}

class TicketsUseError extends TicketsState {
  final String message;
  const TicketsUseError(this.message);

  @override
  List<Object?> get props => [message];
}

class TicketsLoadError extends TicketsState {
  final String message;
  const TicketsLoadError(this.message);

  @override
  List<Object?> get props => [message];
}
