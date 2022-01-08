/// A user's email and token.
class AuthenticatedUser {
  final String email;
  final String token;

  AuthenticatedUser({
    required this.email,
    required this.token,
  });

  @override
  String toString() => '$email | $token';
}
