import 'dart:async';

import 'package:coffeecard/model/account/user.dart';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import '../../persistence/repositories/account_repository.dart';
import '../../persistence/repositories/authentication_repository.dart';

/*
* Large parts of this file is taken from the flutter login example in https://github.com/felangel/bloc as of the d505e54 commit
* The code is used under the following license:
* MIT License

Copyright (c) 2018 Felix Angelov

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
* */

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({
    @required AuthenticationRepository authenticationRepository,
    @required AccountRepository accountRepository,
  })  : assert(authenticationRepository != null),
        assert(accountRepository != null),
        _authenticationRepository = authenticationRepository,
        _accountRepository = accountRepository,
        super(const AuthenticationState.unknown()) {
    _authenticationStatusSubscription = _authenticationRepository.status.listen(
          (status) => add(AuthenticationStatusChanged(status)), //Adds the internally to itself and creates a proper response in mapEventToState
    );
  }

  final AuthenticationRepository _authenticationRepository;
  final AccountRepository _accountRepository;
  StreamSubscription<AuthenticationStatus> _authenticationStatusSubscription;

  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationEvent event,
      ) async* {
    if (event is AuthenticationStatusChanged) {
      yield await _mapAuthenticationStatusChangedToState(event);
    } else if (event is AuthenticationLogoutRequested) {
      _authenticationRepository.logOut();
    }
  }

  @override
  Future<void> close() {
    _authenticationStatusSubscription?.cancel();
    _authenticationRepository.dispose();
    return super.close();
  }

  Future<AuthenticationState> _mapAuthenticationStatusChangedToState(
      AuthenticationStatusChanged event,
      ) async {
    switch (event.status) {
      case AuthenticationStatus.unauthenticated:
        return const AuthenticationState.unauthenticated();
      case AuthenticationStatus.authenticated:
        final user = User("name", "email", "password", 1, false); //TODO Yield an authenticating event for a loading/splash screen that the main method can change to
        return user != null
            ? AuthenticationState.authenticated(user)
            : const AuthenticationState.unauthenticated();
      default:
        return const AuthenticationState.unknown();
    }
  }

  Future<User> _tryGetUser() async {
    try {
      final user = await _accountRepository.getUser();
      return user;
    } on Exception {
      return null; //TODO proper error handling
    }
  }
}
