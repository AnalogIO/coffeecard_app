part of 'authentication_cubit.dart';

class AuthenticationState extends Equatable {
  final AuthStatus status;
  final AuthenticatedUser? authenticatedUser;

  const AuthenticationState._({
    this.status = AuthStatus.unknown,
    this.authenticatedUser,
  });

  const AuthenticationState.unknown() : this._();

  const AuthenticationState.authenticated(AuthenticatedUser authenticatedUser)
      : this._(
          status: AuthStatus.authenticated,
          authenticatedUser: authenticatedUser,
        );

  const AuthenticationState.unauthenticated()
      : this._(status: AuthStatus.unauthenticated);

  @override
  List<Object?> get props =>
      [status, authenticatedUser?.email, authenticatedUser?.token];

  @override
  String toString() {
    return 'AuthenticationState{status: $status, user: $authenticatedUser}';
  }
}
