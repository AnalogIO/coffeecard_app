import 'dart:convert';

import 'package:coffeecard/features/authentication/data/models/authenticated_user_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final model = AuthenticatedUserModel(
    email: 'email',
    token: 'token',
    encodedPasscode: 'passcode',
    sessionTimeout: const Duration(hours: 2),
    lastLogin: DateTime.parse('2012-02-27'),
  );

  group('fromJson', () {
    test('should return json', () {
      // arrange
      final jsonString = fixture('authenticated_user.json');

      // act
      final actual = AuthenticatedUserModel.fromJson(
        json.decode(jsonString) as Map<String, dynamic>,
      );

      // assert
      expect(actual, model);
    });
  });
  group('toJson', () {
    test('should return map', () {
      // act
      final actual = model.toJson();

      // assert
      final expected = {
        'email': 'email',
        'token': 'token',
        'passcode': 'passcode',
        'last_login': '2012-02-27 00:00:00.000',
        'session_timeout': '2:00:00.000000',
      };

      expect(actual, expected);
    });
  });
}
