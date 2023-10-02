import 'package:coffeecard/features/authentication/domain/entities/authenticated_user.dart';

class AuthenticatedUserModel extends AuthenticatedUser {
  const AuthenticatedUserModel({
    required super.email,
    required super.token,
    required super.encodedPasscode,
    super.lastLogin,
    super.sessionTimeout,
  });

  factory AuthenticatedUserModel.fromJson(Map<String, dynamic> json) {
    final lastLogin =
        _nullOrValue<DateTime>(json, 'last_login', (r) => DateTime.parse(r));
    final sessionTimeout = _nullOrValue<Duration>(
      json,
      'session_timeout',
      (r) => _parseDuration(r),
    );

    return AuthenticatedUserModel(
      email: json['email'] as String,
      token: json['token'] as String,
      encodedPasscode: json['passcode'] as String,
      lastLogin: lastLogin,
      sessionTimeout: sessionTimeout,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'token': token,
      'passcode': encodedPasscode,
      'last_login': lastLogin.toString(),
      'session_timeout': sessionTimeout.toString(),
    };
  }

  static T? _nullOrValue<T>(
    Map<String, dynamic> m,
    String key,
    T? Function(String) callback,
  ) {
    if (m[key] == 'null') {
      return null;
    }

    return callback(m[key]! as String);
  }

  static Duration _parseDuration(String s) {
    int hours = 0;
    int minutes = 0;

    final parts = s.split(':');
    if (parts.length > 2) {
      hours = int.parse(parts[parts.length - 3]);
    }
    if (parts.length > 1) {
      minutes = int.parse(parts[parts.length - 2]);
    }

    return Duration(hours: hours, minutes: minutes);
  }
}
