import 'package:equatable/equatable.dart';

class AuthenticatedUser extends Equatable {
  final String email;
  final String token;
  final String encodedPasscode;
  final DateTime? lastLogin;
  final Duration? sessionTimeout;

  const AuthenticatedUser({
    required this.email,
    required this.token,
    required this.encodedPasscode,
    this.lastLogin,
    this.sessionTimeout,
  });

  @override
  List<Object?> get props => [
        email,
        token,
        encodedPasscode,
        lastLogin,
        sessionTimeout,
      ];
}
