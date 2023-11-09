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

  const TicketsLoaded({required this.tickets});

  @override
  List<Object?> get props => [tickets];
}

class TicketUsing extends TicketsLoaded {
  const TicketUsing({required super.tickets});
}

class TicketUsed extends TicketsLoaded {
  final Receipt receipt;

  const TicketUsed({required this.receipt, required super.tickets});

  @override
  List<Object?> get props => [receipt, tickets];
}

class TicketsUseError extends TicketsState {
  final String message;
  const TicketsUseError({required this.message});

  @override
  List<Object?> get props => [message];
}

class TicketsLoadError extends TicketsState {
  final String message;
  const TicketsLoadError({required this.message});

  @override
  List<Object?> get props => [message];
}
