import 'package:coffeecard/persistence/repositories/authentication_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthenticationService authService;

  LoginBloc({required this.authService}) : super(const LoginState()) {
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
        emit(state.copyWith(route: LoginRoute.passcode, passcode: ''));
      }
    });
    on<LoginPasscodeInput>((event, emit) async {
      final newPasscode = state.passcode + event.input;
      final loading = newPasscode.length == 4;
      emit(
        state.copyWith(
          passcode: newPasscode,
          loading: loading,
        ),
      );
      if (loading) {
        final loginStatus = await authService.logIn(state.email, newPasscode);
        if (loginStatus is FailedLogin) {
          emit(state.copyWith(passcode: '', error: loginStatus.errorMessage));
        } else {
          emit(state.copyWith(loginSuccess: true));
        }
      }
    });
    on<LoginClearPasscode>((event, emit) {
      emit(state.copyWith(passcode: ''));
    });
    on<LoginAsAnotherUser>((event, emit) {
      // TODO: logout
      emit(
        state.copyWith(
          email: '',
          passcode: '',
          route: LoginRoute.email,
        ),
      );
    });
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
