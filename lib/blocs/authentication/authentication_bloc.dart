import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:coffeecard/model/account/user.dart';
import 'package:equatable/equatable.dart';

import '../../persistence/repositories/account_repository.dart';
import '../../persistence/repositories/authentication_repository.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationRepository _authenticationRepository;
  final AccountRepository _accountRepository;
  StreamSubscription<AuthenticationStatus> _authenticationStatusSubscription;

  AuthenticationBloc(this._authenticationRepository, this._accountRepository)
      : super(const AuthenticationState.unknown()) {
    // Adds the internally to itself and creates a proper response in mapEventToState
    _authenticationStatusSubscription =
        _authenticationRepository.status.listen((status) => add(AuthenticationStatusChanged(status)));
  }

  @override
  Stream<AuthenticationState> mapEventToState(AuthenticationEvent event) async* {
    if (event is AuthenticationStatusChanged) {
      yield await _mapAuthenticationStatusChangedToState(event);
    } else if (event is AuthenticationLogoutRequested) {
      _authenticationRepository.logOut();
    }
  }

  @override
  Future<void> close() {
    _authenticationStatusSubscription.cancel();
    _authenticationRepository.dispose();
    return super.close();
  }

  Future<AuthenticationState> _mapAuthenticationStatusChangedToState(AuthenticationStatusChanged event) async {
    switch (event.status) {
      case AuthenticationStatus.unauthenticated:
        return const AuthenticationState.unauthenticated();
      case AuthenticationStatus.authenticated:
        final user =
            await _tryGetUser(); //TODO Yield an authenticating event for a loading/splash screen that the main method can change to
        return user != null ? AuthenticationState.authenticated(user) : const AuthenticationState.unauthenticated();
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
