import 'dart:convert';

import 'package:coffeecard/features/authentication.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const model = AuthenticationInfo(
    email: 'a',
    token: 'b',
    encodedPasscode: 'c',
  );

  group('fromJson', () {
    test('should return model', () {
      // arrange
      const jsonString = '{"email":"a","token":"b","encodedPasscode":"c"}';

      // act
      final actual = AuthenticationInfo.fromJson(
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
      final expected = {'email': 'a', 'token': 'b', 'encodedPasscode': 'c'};

      expect(actual, expected);
    });
  });
}
