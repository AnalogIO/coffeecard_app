import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'session_timeout_state.dart';

typedef SessionTimeout = (String, Duration?);

const List<SessionTimeout> entries = [
  ('2 seconds', Duration(seconds: 2)),
  ('2 hours', Duration(hours: 2)),
  ('Never', null),
];

class SessionTimeoutCubit extends Cubit<SessionTimeoutState> {
  SessionTimeoutCubit()
      : super(SessionTimeoutState(entries: entries, selected: entries.first));

  SessionTimeout selected() => state.selected;

  Future<void> setSelected(SessionTimeout sessionTimeout) async {
    emit(
      state.copyWith(
        selected: entries.firstWhere((element) => element == sessionTimeout),
      ),
    );
  }
}
