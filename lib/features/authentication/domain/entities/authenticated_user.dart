import 'package:equatable/equatable.dart';

class AuthenticatedUser extends Equatable {
  final String email;
  final String token;
  final String encodedPasscode;
  final DateTime? lastLogin;

  const AuthenticatedUser({
    required this.email,
    required this.token,
    required this.encodedPasscode,
    this.lastLogin,
  });

  @override
  List<Object?> get props => [email, token, encodedPasscode, lastLogin];
}
