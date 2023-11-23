import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

class AuthenticatedUser extends Equatable {
  final String email;
  final String token;
  final String encodedPasscode;
  final Option<DateTime> lastLogin;
  final Option<Duration> sessionTimeout;

  const AuthenticatedUser({
    required this.email,
    required this.token,
    required this.encodedPasscode,
    required this.lastLogin,
    required this.sessionTimeout,
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
