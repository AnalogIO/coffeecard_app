part of 'session_timeout_cubit.dart';

class SessionTimeoutState extends Equatable {
  final List<SessionTimeout> entries;
  final SessionTimeout selected;

  const SessionTimeoutState({required this.entries, required this.selected});

  @override
  List<Object> get props => [entries, selected];

  SessionTimeoutState copyWith({
    List<SessionTimeout>? entries,
    SessionTimeout? selected,
  }) {
    return SessionTimeoutState(
      entries: entries ?? this.entries,
      selected: selected ?? this.selected,
    );
  }
}
