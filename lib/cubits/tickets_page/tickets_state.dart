part of 'tickets_cubit.dart';

abstract class TicketsState {
  const TicketsState();
}

class TicketsLoading extends TicketsState {
  const TicketsLoading();
}

class TicketsLoaded extends TicketsState {
  final List<TicketDto> tickets;

  const TicketsLoaded(this.tickets);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TicketsLoaded && listEquals(other.tickets, tickets);
  }

  @override
  int get hashCode => tickets.hashCode;
}

class TicketsError extends TicketsState {
  final String message;
  const TicketsError(this.message);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TicketsError && other.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}
