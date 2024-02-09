part of 'authentication_cubit.dart';

class AuthenticationState extends Equatable {
  final AuthenticationStatus status;
  final AuthenticationInfo? authenticationInfo;

  const AuthenticationState._({
    this.status = AuthenticationStatus.unknown,
    this.authenticationInfo,
  });

  const AuthenticationState.unknown() : this._();

  const AuthenticationState.authenticated(AuthenticationInfo authenticationInfo)
      : this._(
          status: AuthenticationStatus.authenticated,
          authenticationInfo: authenticationInfo,
        );

  const AuthenticationState.unauthenticated()
      : this._(status: AuthenticationStatus.unauthenticated);

  @override
  List<Object?> get props => [
        status,
        authenticationInfo,
      ];

  @override
  String toString() {
    return 'AuthenticationState{status: $status, user: $authenticationInfo}';
  }
}

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

extension AuthenticationStatusIs on AuthenticationStatus {
  bool get isUnknown => this == AuthenticationStatus.unknown;
  bool get isAuthenticated => this == AuthenticationStatus.authenticated;
  bool get isUnauthenticated => this == AuthenticationStatus.unauthenticated;
}
