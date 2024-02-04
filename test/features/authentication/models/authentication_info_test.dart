import 'dart:convert';

import 'package:coffeecard/features/authentication.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const testAuthenticationInfo = AuthenticationInfo(
    email: 'a',
    token: 'b',
    encodedPasscode: 'c',
  );

  test(
    'GIVEN a json encoded authentication info '
    'WHEN fromJson is called '
    'THEN it should return an AuthenticationInfo object with expected values',
    () {
      // arrange
      const jsonEncodedInfo = '{"email":"a","token":"b","encodedPasscode":"c"}';

      // act
      final actual = AuthenticationInfo.fromJson(
        json.decode(jsonEncodedInfo) as Map<String, dynamic>,
      );

      // assert
      expect(actual, testAuthenticationInfo);
    },
  );

  test(
    'GIVEN an AuthenticationInfo object '
    'WHEN toJson is called '
    'THEN it should return a json encoded map with expected values',
    () {
      // arrange
      final expected = {'email': 'a', 'token': 'b', 'encodedPasscode': 'c'};

      // act
      final actual = testAuthenticationInfo.toJson();

      // assert
      expect(actual, expected);
    },
  );
}
