import 'package:equatable/equatable.dart';

class AuthenticatedUser extends Equatable {
  final String email;
  final String token;

  const AuthenticatedUser({
    required this.email,
    required this.token,
  });

  @override
  List<Object?> get props => [email, token];
}
