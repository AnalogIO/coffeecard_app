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
  final List<Ticket> tickets;

  const TicketsLoaded({required this.tickets});

  @override
  List<Object?> get props => [tickets];
}

class TicketsLoadError extends TicketsState {
  final String message;
  const TicketsLoadError({required this.message});

  @override
  List<Object?> get props => [message];
}

/// Superclass for all actions that can be performed on the tickets.
sealed class TicketsAction extends TicketsLoaded {
  const TicketsAction({required super.tickets});
}

class TicketUsing extends TicketsAction {
  const TicketUsing({required super.tickets});
}

class TicketUsed extends TicketsAction {
  final Receipt receipt;

  const TicketUsed({required this.receipt, required super.tickets});

  @override
  List<Object?> get props => [receipt, tickets];
}

class TicketsUseError extends TicketsAction {
  final String message;
  const TicketsUseError({required this.message, required super.tickets});

  @override
  List<Object?> get props => [message, tickets];
}

class TicketsRefreshing extends TicketsLoaded {
  const TicketsRefreshing({required super.tickets});

  @override
  List<Object?> get props => [tickets];
}
