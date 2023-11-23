import 'dart:convert';

import 'package:coffeecard/features/authentication/data/models/authenticated_user_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final model = AuthenticatedUserModel(
    email: 'email',
    token: 'token',
    encodedPasscode: 'passcode',
    sessionTimeout: some(const Duration(hours: 2)),
    lastLogin: some(DateTime.parse('2012-02-27')),
  );

  final modelNullFields = AuthenticatedUserModel(
    email: 'email',
    token: 'token',
    encodedPasscode: 'passcode',
    lastLogin: none(),
    sessionTimeout: none(),
  );

  group('fromJson', () {
    test('should return model', () {
      // arrange
      final jsonString = fixture('authenticated_user/authenticated_user.json');

      // act
      final actual = AuthenticatedUserModel.fromJson(
        json.decode(jsonString) as Map<String, dynamic>,
      );

      // assert
      expect(actual, model);
    });

    test('should return model without lastLogin and sessionTimeout', () {
      // arrange
      final jsonString =
          fixture('authenticated_user/authenticated_user_null_fields.json');

      // act
      final actual = AuthenticatedUserModel.fromJson(
        json.decode(jsonString) as Map<String, dynamic>,
      );

      // assert
      expect(actual, modelNullFields);
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

    test('should return map with null fields', () {
      // act
      final actual = modelNullFields.toJson();

      // assert
      final expected = {
        'email': 'email',
        'token': 'token',
        'passcode': 'passcode',
        'last_login': 'null',
        'session_timeout': 'null',
      };

      expect(actual, expected);
    });
  });
}
