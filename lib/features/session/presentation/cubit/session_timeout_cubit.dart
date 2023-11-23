import 'package:bloc/bloc.dart';
import 'package:coffeecard/features/session/domain/usecases/get_session_details.dart';
import 'package:coffeecard/features/session/domain/usecases/save_session_details.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

part 'session_timeout_state.dart';

typedef SessionTimeout = (String, Duration?);

const List<SessionTimeout> entries = [
  ('2 seconds', Duration(seconds: 2)),
  ('2 hours', Duration(hours: 2)),
  ('Never', null),
];

class SessionTimeoutCubit extends Cubit<SessionTimeoutState> {
  final GetSessionDetails getSessionDetails;
  final SaveSessionDetails saveSessionDetails;

  SessionTimeoutCubit({
    required this.getSessionDetails,
    required this.saveSessionDetails,
  }) : super(
          SessionTimeoutState(
            entries: entries,
            selected: entries.first,
          ),
        );

  SessionTimeout selected() => state.selected;

  Future<void> setSelected(SessionTimeout sessionTimeout) async {
    final e = entries.firstWhere((element) => element == sessionTimeout);

    final sessionDetails = await getSessionDetails();

    sessionDetails.map(
      (sessionDetails) async => await saveSessionDetails(
        lastLogin: sessionDetails.lastLogin,
        sessionTimeout: some(e.$2),
      ),
    );

    emit(
      state.copyWith(
        selected: e,
      ),
    );
  }
}
