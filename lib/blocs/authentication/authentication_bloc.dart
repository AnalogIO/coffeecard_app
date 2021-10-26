import 'dart:async';

import 'package:coffeecard/model/account/user.dart';
import 'package:coffeecard/persistence/repositories/authentication_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationService _authenticationService;

  // TODO Consider if should be late (makes it nullable). The field is not set in constructor since it accesses authenticationRepository
  late StreamSubscription<AuthenticationStatus>
      _authenticationStatusSubscription;

  AuthenticationBloc(this._authenticationService)
      : super(const AuthenticationState.unknown()) {
    // Adds the internally to itself and creates a proper response in mapEventToState
    _authenticationStatusSubscription = _authenticationService.status
        .listen((status) => add(AuthenticationStatusChanged(status)));
  }

  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationEvent event) async* {
    if (event is AuthenticationStatusChanged) {
      yield await _mapAuthenticationStatusChangedToState(event);
    } else if (event is AuthenticationLogoutRequested) {
      _authenticationService.logOut();
    }
  }

  Future<AuthenticationState> _mapAuthenticationStatusChangedToState(
      AuthenticationStatusChanged event) async {
    switch (event.status) {
      case AuthenticationStatus.unauthenticated:
        return const AuthenticationState.unauthenticated();
      case AuthenticationStatus.authenticated:
        //TODO Yield an authenticating event for a loading/splash screen that the main method can change to
        //TODO Hamdle error handling
        return AuthenticationState.authenticated(
            await _authenticationService.getUser());
      default:
        return const AuthenticationState.unknown();
    }
  }

  @override
  Future<void> close() {
    _authenticationStatusSubscription.cancel();
    _authenticationService.dispose();
    return super.close();
  }
}
