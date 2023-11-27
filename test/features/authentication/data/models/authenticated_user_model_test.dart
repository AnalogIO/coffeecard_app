import 'dart:convert';

import 'package:coffeecard/features/authentication/data/models/authenticated_user_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const model = AuthenticatedUserModel(
    email: 'email',
    token: 'token',
    encodedPasscode: 'passcode',
  );

  group('fromJson', () {
    test('should return model', () {
      // arrange
      final jsonString = json.encode({
        'email': 'email',
        'token': 'token',
        'passcode': 'passcode',
      });

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
