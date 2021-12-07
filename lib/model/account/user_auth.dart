/// A user's email and token.
class UserAuth {
  final String email;
  final String token;

  UserAuth({
    required this.email,
    required this.token,
  });

  @override
  String toString() => '$email | $token';
}
