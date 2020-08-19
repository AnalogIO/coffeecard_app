import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:coffeecard/persistence/repositories/authentication_repository.dart';
import 'package:dio/dio.dart';
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
      if (event.keyPress == "reset")
        {
          final currentPassword = state.password;
          if (currentPassword.isNotEmpty) {
            yield state.copyWith(email: state.email, password: currentPassword.substring(0, currentPassword.length - 1));
          }
        }
      else {
        final newPassword = state.password + event.keyPress;
        if (newPassword.length == 4){
          yield state.copyWith(password: newPassword);
          await authenticationRepository.logIn(username: state.email, password: newPassword);
        }
        else {
          yield state.copyWith(password: newPassword, error: "");
        }
      }
    }
    catch (error){
      if (error is DioError)
        {
          final Map<String, dynamic> errorMessage = error.response.data as Map<String, dynamic>;
          yield state.copyWith(password: "", error: errorMessage["message"] as String );
        }
      else {
        yield state.copyWith(password: "", error: error.toString()); //TODO do proper error handling
      }
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
    yield state.copyWith(email: event.email);
  }

  Stream<LoginState> mapLoginGoBack(LoginGoBack event) async* {
    yield state.copyWith(onPage: OnPage.inputEmail, password: "");
  }

  bool validateEmail(String email){
    final RegExp regExEmail = RegExp(r"^[^@ \t\r\n]+@[^@ \t\r\n]+\.[^@ \t\r\n]+"); //[^@ \\t\\r\\n] matches for anything other than @, space, tab, new lines repetitions of a non-whitespace character.
    if (regExEmail.hasMatch(email)) {
      return true;
    }
    return false;
  }


}
