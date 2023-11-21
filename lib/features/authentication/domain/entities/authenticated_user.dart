import 'package:equatable/equatable.dart';

class AuthenticatedUser extends Equatable {
  final String email;
  final String token;
  final String encodedPasscode;

  const AuthenticatedUser({
    required this.email,
    required this.token,
    required this.encodedPasscode,
  });

  @override
  List<Object?> get props => [
        email,
        token,
        encodedPasscode,
      ];
}
