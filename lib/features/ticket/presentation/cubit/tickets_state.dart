part of 'tickets_cubit.dart';

abstract class TicketsState extends Equatable {
  final bool isBarista;

  const TicketsState({required this.isBarista});

  TicketsState copyWith({bool? isBarista});
}

class TicketsLoading extends TicketsState {
  const TicketsLoading({required super.isBarista});

  @override
  List<Object?> get props => [isBarista];

  @override
  TicketsState copyWith({bool? isBarista}) {
    return TicketsLoading(isBarista: isBarista ?? this.isBarista);
  }
}

class TicketsLoaded extends TicketsState {
  final List<TicketCount> tickets;
  final List<TicketCount> filteredTickets;

  const TicketsLoaded({
    required super.isBarista,
    required this.tickets,
    required this.filteredTickets,
  });

  @override
  List<Object?> get props => [tickets, isBarista, filteredTickets];

  @override
  TicketsState copyWith({
    bool? isBarista,
    List<TicketCount>? tickets,
    List<TicketCount>? filteredTickets,
  }) {
    return TicketsLoaded(
      isBarista: isBarista ?? this.isBarista,
      tickets: tickets ?? this.tickets,
      filteredTickets: filteredTickets ?? this.filteredTickets,
    );
  }
}

class TicketUsing extends TicketsLoaded {
  const TicketUsing({
    required super.isBarista,
    required super.tickets,
    required super.filteredTickets,
  });
}

class TicketUsed extends TicketsLoaded {
  final Receipt receipt;

  const TicketUsed({
    required this.receipt,
    required super.tickets,
    required super.isBarista,
    required super.filteredTickets,
  });

  @override
  List<Object?> get props => [receipt, tickets, isBarista];

  @override
  TicketsState copyWith({
    bool? isBarista,
    List<TicketCount>? tickets,
    Receipt? receipt,
    List<TicketCount>? filteredTickets,
  }) {
    return TicketUsed(
      isBarista: isBarista ?? this.isBarista,
      tickets: tickets ?? this.tickets,
      receipt: receipt ?? this.receipt,
      filteredTickets: filteredTickets ?? this.filteredTickets,
    );
  }
}

class TicketsUseError extends TicketsState {
  final String message;
  const TicketsUseError({required this.message, required super.isBarista});

  @override
  List<Object?> get props => [message, isBarista];

  @override
  TicketsState copyWith({bool? isBarista, String? message}) {
    return TicketsUseError(
      message: message ?? this.message,
      isBarista: isBarista ?? this.isBarista,
    );
  }
}

class TicketsLoadError extends TicketsState {
  final String message;
  const TicketsLoadError({required this.message, required super.isBarista});

  @override
  List<Object?> get props => [message, isBarista];

  @override
  TicketsState copyWith({bool? isBarista, String? message}) {
    return TicketsLoadError(
      isBarista: isBarista ?? this.isBarista,
      message: message ?? this.message,
    );
  }
}
