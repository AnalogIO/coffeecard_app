import 'package:coffeecard/features/authentication/domain/entities/authenticated_user.dart';
import 'package:fpdart/fpdart.dart';

class AuthenticatedUserModel extends AuthenticatedUser {
  const AuthenticatedUserModel({
    required super.email,
    required super.token,
    required super.encodedPasscode,
    required super.lastLogin,
    required super.sessionTimeout,
  });

  factory AuthenticatedUserModel.fromJson(Map<String, dynamic> json) {
    final lastLogin =
        _nullOrValue<DateTime>(json, 'last_login', DateTime.parse);
    final sessionTimeout = _nullOrValue<Duration>(
      json,
      'session_timeout',
      _parseDuration,
    );

    return AuthenticatedUserModel(
      email: json['email'] as String,
      token: json['token'] as String,
      encodedPasscode: json['passcode'] as String,
      lastLogin: lastLogin,
      sessionTimeout: sessionTimeout,
    );
  }

  static String? _optionToString<T>(Option<T> option) {
    return option.match(() => 'null', (value) => value.toString());
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'token': token,
      'passcode': encodedPasscode,
      'last_login': _optionToString(lastLogin),
      'session_timeout': _optionToString(sessionTimeout),
    };
  }

  static Option<T> _nullOrValue<T>(
    Map<String, dynamic> m,
    String key,
    T Function(String) callback,
  ) {
    if (!m.containsKey(key)) {
      return none();
    }

    final val = m[key] as String;

    if (val == 'null') {
      return none();
    }

    return Some(callback(val));
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
