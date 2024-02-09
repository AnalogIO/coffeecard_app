import 'package:coffeecard/features/authentication.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'authentication_state.dart';

// We might consider changing this back to a bloc if we want different events to
// trigger a logout (for instance, when the user requests logs out themselves
// vs the user's token expires and fails to renew).
class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationCubit(this.repository) : super(const AuthenticationState._());

  final AuthenticationRepository repository;

  Future<void> appStarted() async {
    return repository
        .getAuthenticationInfo()
        .match(
          AuthenticationState.unauthenticated,
          AuthenticationState.authenticated,
        )
        .map(emit)
        .run();
  }

  Future<void> authenticated(AuthenticationInfo info) => repository
      .saveAuthenticationInfo(info)
      .map((_) => AuthenticationState.authenticated(info))
      .map(emit)
      .run();

  Future<void> unauthenticated() => repository
      .clearAuthenticationInfo()
      .map((_) => const AuthenticationState.unauthenticated())
      .map(emit)
      .run();
}
