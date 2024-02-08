part of 'session_timeout_cubit.dart';

abstract class SessionTimeoutState extends Equatable {
  final List<SessionTimeout> entries;

  const SessionTimeoutState({required this.entries});

  @override
  List<Object?> get props => [entries];
}

class SessionTimeoutLoading extends SessionTimeoutState {
  const SessionTimeoutLoading({required super.entries});
}

class SessionTimeoutLoaded extends SessionTimeoutState {
  final SessionTimeout selected;

  const SessionTimeoutLoaded({required super.entries, required this.selected});

  @override
  List<Object> get props => [entries, selected];

  SessionTimeoutLoaded copyWith({
    List<SessionTimeout>? entries,
    SessionTimeout? selected,
  }) {
    return SessionTimeoutLoaded(
      entries: entries ?? this.entries,
      selected: selected ?? this.selected,
    );
  }
}
