import 'package:bloc/bloc.dart';
import 'package:coffeecard/features/session/domain/usecases/get_session_details.dart';
import 'package:coffeecard/features/session/domain/usecases/save_session_details.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

part 'session_timeout_state.dart';

typedef SessionTimeout = (String, Duration?);

class SessionTimeoutCubit extends Cubit<SessionTimeoutState> {
  final GetSessionDetails getSessionDetails;
  final SaveSessionDetails saveSessionDetails;

  final List<SessionTimeout> entries;

  SessionTimeoutCubit({
    required this.getSessionDetails,
    required this.saveSessionDetails,
    required this.entries,
  }) : super(SessionTimeoutLoading(entries: entries));

  SessionTimeout _getMatchingEntry(Duration? duration) =>
      entries.firstWhere((sessionTimeout) => sessionTimeout.$2 == duration);

  SessionTimeout selected() => state is SessionTimeoutLoaded
      ? (state as SessionTimeoutLoaded).selected
      : _getMatchingEntry(null);

  Future<void> load() async {
    final sessionDetails = await getSessionDetails();

    final selectedDuration = sessionDetails.match(
      () => null,
      (sessionDetails) => sessionDetails.sessionTimeout.getOrElse(() => null),
    );

    final entry = _getMatchingEntry(selectedDuration);

    emit(SessionTimeoutLoaded(entries: entries, selected: entry));
  }

  Future<void> setSelected(SessionTimeout sessionTimeout) async {
    emit(SessionTimeoutLoading(entries: entries));

    final entry = _getMatchingEntry(sessionTimeout.$2);

    final sessionDetails = await getSessionDetails();

    final Option<Duration?> timeout = Option.of(entry.$2);

    sessionDetails.match(
      () async =>
          await saveSessionDetails(lastLogin: none(), sessionTimeout: timeout),
      (sessionDetails) async => await saveSessionDetails(
        lastLogin: sessionDetails.lastLogin,
        sessionTimeout: timeout,
      ),
    );

    emit(SessionTimeoutLoaded(entries: entries, selected: entry));
  }
}
