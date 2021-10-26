import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(const LoginState()) {
    on<LoginEmailChange>((event, emit) {
      emit(state.copyWith(email: event.email));
    });
    on<LoginEmailSubmit>((event, emit) {
      final email = state.email.trim();
      if (email.isEmpty) {
        emit(state.copyWith(error: 'Please enter an email'));
      } else if (!isValidEmail(email)) {
        emit(state.copyWith(error: 'Please enter a valid email'));
      } else {
        emit(state.copyWith(route: LoginRoute.passcode, passcode: '12'));
      }
    });
    on<LoginPasscodeInput>((event, emit) {
      final newPasscode = state.passcode + event.input;
      final loading = newPasscode.length == 4;
      emit(
        state.copyWith(passcode: newPasscode, loading: loading),
      );
      if (loading) {}
    });
    // on<LoginAsAnotherUser>((event, emit) {
    //   // TODO: logout
    //   emit(
    //     state.copyWith(
    //       email: '',
    //       route: LoginRoute.email,
    //       passcode: '',
    //     ),
    //   );
    // });
    on<LoginEvent>((event, emit) {
      print(state);
      print(event.runtimeType);
    });
  }

  bool isValidEmail(String email) =>
      RegExp(r'^[^@ \t\r\n]+@[^@ \t\r\n]+\.[^@ \t\r\n]+').hasMatch(email);
}

// extension EmailValidator on String {
//   // [^@ \\t\\r\\n] matches for anything other than @, space,
//   // tab, newlines and repetitions of a non-whitespace character.
//   bool isValidEmail() =>
//       RegExp(r"^[^@ \t\r\n]+@[^@ \t\r\n]+\.[^@ \t\r\n]+").hasMatch(this);
// }
