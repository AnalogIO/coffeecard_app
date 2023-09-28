import 'package:coffeecard/features/authentication/domain/entities/authenticated_user.dart';

class AuthenticatedUserModel extends AuthenticatedUser {
  const AuthenticatedUserModel({
    required super.email,
    required super.token,
    required super.encodedPasscode,
    super.lastLogin,
  });

  factory AuthenticatedUserModel.fromJson(Map<String, dynamic> json) {
    return AuthenticatedUserModel(
      email: json['email'] as String,
      token: json['token'] as String,
      encodedPasscode: json['passcode'] as String,
      lastLogin: DateTime.parse(json['lastLogin'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'token': token,
      'passcode': encodedPasscode,
      'lastLogin': lastLogin.toString(),
    };
  }
}
