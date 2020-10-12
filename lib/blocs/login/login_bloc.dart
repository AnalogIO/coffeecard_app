import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:coffeecard/persistence/repositories/authentication_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthenticationRepository authenticationRepository;

  LoginBloc({
    @required this.authenticationRepository,
  })  : assert(authenticationRepository != null),
        super(const LoginState());

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is LoginNumpadPressed){
      yield* mapNumpadPressedToEvent(event);
    }
    else if (event is LoginEmailSubmitted){
      yield* mapLoginEmailSubmitted(event);
    }
    else if (event is LoginEmailChanged) {
      yield* mapLoginEmailChanged(event);
    }
    else if (event is LoginGoBack) {
      yield* mapLoginGoBack(event);
    }
  }

  Stream<LoginState> mapNumpadPressedToEvent(LoginNumpadPressed event) async* {
    try {
      // TODO Avoid string reference to enumeration. Idea: Refactor NumpadPressed Event to have Numpad actions and value (named parameter)

      if (event.keyPress == "reset") {
        final currentPassword = state.password;
        if (currentPassword.isNotEmpty) {
          yield state.copyWith(
              email: state.email, password: currentPassword.substring(0, currentPassword.length - 1), error: "");
        } else {
          yield state.copyWith(error: "");
        }
      }
      else { //User pressed any of the numbers
        final newPassword = state.password + event.keyPress;
        if (newPassword.length == 4) { //The user typed their entire pin
          yield state.copyWith(password: newPassword, isLoading: true);

          final error = await authenticationRepository.logIn(state.email, newPassword);

          yield state.copyWith(password: "", error: error, isLoading: false);
        }
        else { //User is typing their pin
          yield state.copyWith(password: newPassword, error: "");
        }
      }
    }
    catch (error){
        yield state.copyWith(password: "", error: error.toString()); //TODO do proper error handling
    }
  }

  Stream<LoginState> mapLoginEmailSubmitted(LoginEmailSubmitted event) async* {
      if (validateEmail(state.email)) {
        yield state.copyWith(error: "" , onPage: OnPage.inputPassword);
      } else if (state.email.isEmpty) {
        yield state.copyWith(error: "Enter an email");
      } else {
        yield state.copyWith(error: "Enter a valid email");
      }
  }

  Stream<LoginState> mapLoginEmailChanged(LoginEmailChanged event) async* {
    yield state.copyWith(email: event.email, error: "");
  }

  Stream<LoginState> mapLoginGoBack(LoginGoBack event) async* {
    yield state.copyWith(onPage: OnPage.inputEmail, email: "" , password: "", error: "");
  }

  bool validateEmail(String email){
    final RegExp regExEmail = RegExp(r"^[^@ \t\r\n]+@[^@ \t\r\n]+\.[^@ \t\r\n]+"); //[^@ \\t\\r\\n] matches for anything other than @, space, tab, new lines and repetitions of a non-whitespace character.
    if (regExEmail.hasMatch(email)) {
      return true;
    }
    return false;
  }


}
