import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:coffeecard/persistence/repositories/authentication_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import '../../persistence/repositories/account_repository.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthenticationRepository authenticationRepository;

  LoginBloc({
    @required AuthenticationRepository this.authenticationRepository,
  })  : assert(authenticationRepository != null),
        super(const LoginState(password: "", onPage: OnPage.inputEmail));

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    // TODO: implement mapEventToState
    if (event is LoginNumpadPressed){
      yield* mapNumpadPressedToEvent(event);
    }
    else if (event is LoginEmailSubmitted){
      yield* mapLoginEmailSubmitted(event);
    }
    else if (event is LoginEmailChanged)
      yield* mapLoginEmailChanged(event);
  }

  Stream<LoginState> mapNumpadPressedToEvent(LoginNumpadPressed event) async* {
    try {
      if (event.keyPress == "reset")
        {
          yield state.copyWith(username: state.username, password: state.password.substring(0, state.password.length - 1));
        }
      else {
        var currentInput = state.password + event.keyPress;
        if (currentInput.length == 4){
          yield state.copyWith(password: currentInput);
          await authenticationRepository.logIn(username: state.username, password: currentInput);
        }
        else {
          yield state.copyWith(password: currentInput);
        }
      }
    }
    catch (error){
      yield state.copyWith(password: "", error: error.toString()); //TODO do proper error handling
    }
  }

  Stream<LoginState> mapLoginEmailSubmitted(LoginEmailSubmitted event) async* {
      if (validateEmail(state.username))
        yield state.copyWith(password: "", onPage: OnPage.inputPassword); //The empty string is the initial value of the password
      else
        yield state.copyWith(error: "Enter a valid email");
  }

  Stream<LoginState> mapLoginEmailChanged(LoginEmailChanged event) async* {
    yield state.copyWith(username: event.email);
  }

  bool validateEmail(String email){
    final RegExp regExEmail = RegExp(r"^[^@ \t\r\n]+@[^@ \t\r\n]+\.[^@ \t\r\n]+"); //[^@ \\t\\r\\n] matches for anything other than @, space, tab, new lines repetitions of a non-whitespace character.
    if (regExEmail.hasMatch(email)) {
      return true;
    }
    return false;
  }


}
