import 'dart:convert';

import 'package:coffeecard/features/authentication.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const model = AuthenticatedUserModel(
    email: 'email',
    token: 'token',
    encodedPasscode: 'passcode',
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
      };

      expect(actual, expected);
    });
  });
}
