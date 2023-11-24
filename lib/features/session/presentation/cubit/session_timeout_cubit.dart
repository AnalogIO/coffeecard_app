import 'package:bloc/bloc.dart';
import 'package:coffeecard/features/session/domain/usecases/get_session_details.dart';
import 'package:coffeecard/features/session/domain/usecases/save_session_details.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

part 'session_timeout_state.dart';

typedef SessionTimeout = (String, Duration?);

const List<SessionTimeout> entries = [
  ('2 hours', Duration(hours: 2)),
  ('Never', null),
];

class SessionTimeoutCubit extends Cubit<SessionTimeoutState> {
  final GetSessionDetails getSessionDetails;
  final SaveSessionDetails saveSessionDetails;

  SessionTimeoutCubit({
    required this.getSessionDetails,
    required this.saveSessionDetails,
  }) : super(const SessionTimeoutLoading(entries: entries));

  SessionTimeout selected() => state is SessionTimeoutLoaded
      ? (state as SessionTimeoutLoaded).selected
      : entries.firstWhere((element) => element.$2 == null);

  Future<void> load() async {
    final sessionDetails = await getSessionDetails();

    final selected = sessionDetails.match(
      () => null,
      (t) => t.sessionTimeout.getOrElse(() => null),
    );

    final e = entries.firstWhere((element) => element.$2 == selected);

    emit(SessionTimeoutLoaded(entries: entries, selected: e));
  }

  Future<void> setSelected(SessionTimeout sessionTimeout) async {
    emit(const SessionTimeoutLoading(entries: entries));

    final e = entries.firstWhere((element) => element == sessionTimeout);

    final sessionDetails = await getSessionDetails();

    sessionDetails.map(
      (sessionDetails) async => await saveSessionDetails(
        lastLogin: sessionDetails.lastLogin,
        sessionTimeout: e.$2 == null ? none() : some(e.$2),
      ),
    );

    emit(SessionTimeoutLoaded(entries: entries, selected: e));
  }
}
