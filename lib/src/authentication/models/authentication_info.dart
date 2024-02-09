import 'package:equatable/equatable.dart';

typedef _JsonMap = Map<String, dynamic>;

class AuthenticationInfo extends Equatable {
  const AuthenticationInfo({
    required this.email,
    required this.token,
    required this.encodedPasscode,
  });

  AuthenticationInfo.fromJson(_JsonMap json)
      : email = json['email'] as String,
        token = json['token'] as String,
        encodedPasscode = json['encodedPasscode'] as String;

  final String email;
  final String token;
  final String encodedPasscode;

  _JsonMap toJson() => {
        'email': email,
        'token': token,
        'encodedPasscode': encodedPasscode,
      };

  AuthenticationInfo withToken(String token) => AuthenticationInfo(
        token: token,
        email: email,
        encodedPasscode: encodedPasscode,
      );

  @override
  List<Object?> get props => [email, token, encodedPasscode];
}
