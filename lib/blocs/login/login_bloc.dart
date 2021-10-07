import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:coffeecard/persistence/repositories/authentication_service.dart';
import 'package:coffeecard/widgets/components/login/login_numpad.dart';
import 'package:equatable/equatable.dart';

part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthenticationService authenticationService;

  LoginBloc({
    required this.authenticationService,
  }) : super(const LoginState("", "", OnPage.inputEmail));

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is LoginNumpadPressed) {
      yield* mapNumpadPressedToEvent(event);
    } else if (event is LoginEmailSubmitted) {
      yield* mapLoginEmailSubmitted(event);
    } else if (event is LoginEmailChanged) {
      yield* mapLoginEmailChanged(event);
    } else if (event is LoginGoBack) {
      yield* mapLoginGoBack(event);
    }
  }

  Stream<LoginState> mapNumpadPressedToEvent(LoginNumpadPressed event) async* {
    try {
      final action = event.numpadAction;
      if (action is NumpadActionReset) {
        final currentPassword = state.password;
        if (currentPassword.isNotEmpty) {
          yield state.copyWith(email: state.email, password: currentPassword.substring(0, currentPassword.length - 1));
        } else {
          yield state.copyWith();
        }
      } else if (action is NumpadActionAdd) {
        //User pressed any of the numbers
        final newPassword = state.password + action.keypress;
        if (newPassword.length == 4) {
          //The user typed their entire pin
          yield LoginStateLoading(state.email, newPassword, state.onPage);

          final loginStatus = await authenticationService.logIn(state.email, newPassword);

          if (loginStatus is FailedLogin) {
            yield state.copyToErrorState(password: "", error: loginStatus.errorMessage);
          } else {
            //The user logged in successfully
            yield state.copyWith(password: "");
          }
        } else {
          //User is typing their pin
          yield state.copyWith(password: newPassword);
        }
      }
    } catch (error) {
      yield state.copyToErrorState(error: error.toString()); //TODO do proper error handling
    }
  }

  Stream<LoginState> mapLoginEmailSubmitted(LoginEmailSubmitted event) async* {
    if (validateEmail(state.email)) {
      yield state.copyWith(onPage: OnPage.inputPassword);
    } else if (state.email.isEmpty) {
      yield state.copyToErrorState(error: "Enter an email");
    } else {
      yield state.copyToErrorState(error: "Enter a valid email");
    }
  }

  Stream<LoginState> mapLoginEmailChanged(LoginEmailChanged event) async* {
    yield state.copyWith(email: event.email);
  }

  //TODO Consider removing this method??
  Stream<LoginState> mapLoginGoBack(LoginGoBack event) async* {
    yield state.copyWith(onPage: OnPage.inputEmail, email: "", password: "");
  }

  bool validateEmail(String email) {
    final RegExp regExEmail = RegExp(
        r"^[^@ \t\r\n]+@[^@ \t\r\n]+\.[^@ \t\r\n]+"); //[^@ \\t\\r\\n] matches for anything other than @, space, tab, new lines and repetitions of a non-whitespace character.
    if (regExEmail.hasMatch(email)) {
      return true;
    }
    return false;
  }
}
