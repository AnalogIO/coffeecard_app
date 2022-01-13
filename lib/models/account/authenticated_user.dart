import 'package:equatable/equatable.dart';

/// A user's email and token.
class AuthenticatedUser extends Equatable {
  final String email;
  final String token;

  const AuthenticatedUser({
    required this.email,
    required this.token,
  });

  @override
  String toString() => '$email | $token';

  @override
  List<Object?> get props => [email, token];
}
