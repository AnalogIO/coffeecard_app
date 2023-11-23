import 'package:coffeecard/features/session/domain/entities/session_details.dart';
import 'package:fpdart/fpdart.dart';

class SessionDetailsModel extends SessionDetails {
  const SessionDetailsModel({
    required super.sessionTimeout,
    required super.lastLogin,
  });

  factory SessionDetailsModel.fromJson(Map<String, dynamic> json) {
    return SessionDetailsModel(
      sessionTimeout: _parseOption(json, 'session_timeout', _parseDuration),
      lastLogin: _parseOption(json, 'last_login', DateTime.parse),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'last_login': _optionToString(lastLogin),
      'session_timeout': _optionToString(sessionTimeout),
    };
  }

  static String? _optionToString<T>(Option<T> option) {
    return option.match(() => 'null', (value) => value.toString());
  }

  static Option<T> _parseOption<T>(
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
