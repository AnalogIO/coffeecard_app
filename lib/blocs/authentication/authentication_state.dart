part of 'authentication_bloc.dart';

class AuthState extends Equatable {
  final AuthStatus status;
  final UserAuth? userAuth;

  const AuthState._({
    this.status = AuthStatus.unknown,
    this.userAuth,
  });

  const AuthState.unknown() : this._();

  const AuthState.authenticated(UserAuth userAuth)
      : this._(
          status: AuthStatus.authenticated,
          userAuth: userAuth,
        );

  const AuthState.unauthenticated()
      : this._(status: AuthStatus.unauthenticated);

  @override
  List<Object?> get props => [status, userAuth?.email, userAuth?.token];

  @override
  String toString() {
    return 'AuthenticationState{status: $status, user: $userAuth}';
  }
}
