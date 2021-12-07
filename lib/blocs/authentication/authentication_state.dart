part of 'authentication_bloc.dart';

class AuthState extends Equatable {
  final AuthStatus status;
  final AuthenticatedUser? authenticatedUser;

  const AuthState._({
    this.status = AuthStatus.unknown,
    this.authenticatedUser,
  });

  const AuthState.unknown() : this._();

  const AuthState.authenticated(AuthenticatedUser authenticatedUser)
      : this._(
          status: AuthStatus.authenticated,
          authenticatedUser: authenticatedUser,
        );

  const AuthState.unauthenticated()
      : this._(status: AuthStatus.unauthenticated);

  @override
  List<Object?> get props =>
      [status, authenticatedUser?.email, authenticatedUser?.token];

  @override
  String toString() {
    return 'AuthenticationState{status: $status, user: $authenticatedUser}';
  }
}
