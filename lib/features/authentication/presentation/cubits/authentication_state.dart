part of 'authentication_cubit.dart';

class AuthenticationState extends Equatable {
  final AuthenticationStatus status;
  final AuthenticatedUser? authenticatedUser;

  const AuthenticationState._({
    this.status = AuthenticationStatus.unknown,
    this.authenticatedUser,
  });

  const AuthenticationState.unknown() : this._();

  const AuthenticationState.authenticated(AuthenticatedUser authenticatedUser)
      : this._(
          status: AuthenticationStatus.authenticated,
          authenticatedUser: authenticatedUser,
        );

  const AuthenticationState.unauthenticated()
      : this._(status: AuthenticationStatus.unauthenticated);

  @override
  List<Object?> get props => [
        status,
        authenticatedUser,
      ];

  @override
  String toString() {
    return 'AuthenticationState{status: $status, user: $authenticatedUser}';
  }
}

enum AuthenticationStatus {
  unknown,
  authenticated,
  unauthenticated,
}

extension AuthenticationStatusIs on AuthenticationStatus {
  bool get isUnknown => this == AuthenticationStatus.unknown;
  bool get isAuthenticated => this == AuthenticationStatus.authenticated;
  bool get isUnauthenticated => this == AuthenticationStatus.unauthenticated;
}
