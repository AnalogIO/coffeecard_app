part of 'tickets_cubit.dart';

abstract class TicketsState extends Equatable {
  final bool isBarista;

  const TicketsState({required this.isBarista});

  TicketsState copyWith({bool? isBarista});
}

class TicketsLoading extends TicketsState {
  const TicketsLoading({required super.isBarista});

  @override
  List<Object?> get props => [];

  @override
  TicketsState copyWith({bool? isBarista}) {
    return TicketsLoading(isBarista: isBarista ?? this.isBarista);
  }
}

class TicketsLoaded extends TicketsState {
  final List<TicketCount> tickets;

  const TicketsLoaded({required super.isBarista, required this.tickets});

  @override
  List<Object?> get props => tickets;

  @override
  TicketsState copyWith({bool? isBarista, List<TicketCount>? tickets}) {
    return TicketsLoaded(
      isBarista: isBarista ?? this.isBarista,
      tickets: tickets ?? this.tickets,
    );
  }
}

class TicketUsing extends TicketsLoaded {
  const TicketUsing({required super.isBarista, required super.tickets});
}

class TicketUsed extends TicketsLoaded {
  final Receipt receipt;

  const TicketUsed({
    required this.receipt,
    required super.tickets,
    required super.isBarista,
  });

  @override
  List<Object?> get props => [receipt];

  @override
  TicketsState copyWith({
    bool? isBarista,
    List<TicketCount>? tickets,
    Receipt? receipt,
  }) {
    return TicketUsed(
      isBarista: isBarista ?? this.isBarista,
      tickets: tickets ?? this.tickets,
      receipt: receipt ?? this.receipt,
    );
  }
}

class TicketsUseError extends TicketsState {
  final String message;
  const TicketsUseError({required this.message, required super.isBarista});

  @override
  List<Object?> get props => [message];

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
  List<Object?> get props => [message];

  @override
  TicketsState copyWith({bool? isBarista, String? message}) {
    return TicketsLoadError(
      isBarista: isBarista ?? this.isBarista,
      message: message ?? this.message,
    );
  }
}
