import 'package:coffeecard/features/authentication.dart';

class AuthenticatedUserModel extends AuthenticatedUser {
  const AuthenticatedUserModel({
    required super.email,
    required super.token,
    required super.encodedPasscode,
  });

  factory AuthenticatedUserModel.fromJson(Map<String, dynamic> json) {
    return AuthenticatedUserModel(
      email: json['email'] as String,
      token: json['token'] as String,
      encodedPasscode: json['passcode'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'token': token,
      'passcode': encodedPasscode,
    };
  }
}
