import 'dart:async';

import 'package:coffeecard/model/account/user.dart';

import '../../persistence/repositories/authentication_repository.dart';
import '../../persistence/repositories/account_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

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
        return AuthenticationState.authenticated(User("","",""));
        /* Reimplement
        final user = await _tryGetUser(); //TODO Yield an authenticating event for a loading/splash screen that the main method can change to
        return user != null
            ? AuthenticationState.authenticated(user)
            : const AuthenticationState.unauthenticated();*/
      default:
        return const AuthenticationState.unknown();
    }
  }

  Future<User> _tryGetUser() async {
    try {
      final user = await _accountRepository.getUser();
      return user;
    } on Exception {
      return null;
    }
  }
}
