class UserCredentials {
  final String email;
  final String encodedPasscode;

  UserCredentials({required this.email, required this.encodedPasscode});

  factory UserCredentials.fromJson(Map<String, dynamic> map) {
    return UserCredentials(
      email: map['email'] as String,
      encodedPasscode: map['passcode'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'passcode': encodedPasscode,
    };
  }
}
