import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../persistence/repositories/account_repository.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AccountRepository accountRepository;

  LoginBloc(this.accountRepository)
      : assert(accountRepository != null),
        super(LoginInitial());

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    // TODO: implement mapEventToState
    if (event == LoginNumpadPressed){
      yield* mapNumpadPressedToEvent(event);
    }
    else if (event == LoginEmailEntered){
      yield* mapEmailEntered(event);
    }
  }

  Stream<LoginState> mapNumpadPressedToEvent(LoginNumpadPressed event) async* {
    try {
      var currentInput = state.password + event.keyPress;
      if (currentInput.length == 4){
        yield LoginInProgress(state.username, currentInput);
        accountRepository.login(state.username, currentInput);
        yield LoginSuccess();
      }
      else {
        yield LoginPasswordBeingFilled(state.username, currentInput);
      }
    }
    catch (error){
      yield LoginFailure(state.username, state.onPage, error: error.toString() ); //TODO do proper error handling
    }
  }

  Stream<LoginState> mapEmailEntered(LoginEmailEntered event) async* {
    try {
      validateEmail(event.email);

    }
    catch (error){
      yield LoginFailure(state.username, state.onPage, error: error.toString() ); //TODO do proper error handling
    }
  }

  bool validateEmail(String email){
    final RegExp regExEmail = RegExp(r"^[^@ ]+@[^@ ]+\.[^@ ]+");
    if (regExEmail.hasMatch(email) && (regExEmail.firstMatch(email) == email)) {
      return true;
    }
    return false;
  }


}
