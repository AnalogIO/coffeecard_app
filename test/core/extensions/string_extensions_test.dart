import 'package:coffeecard/core/extensions/string_extensions.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('StringExtensions', () {
    group('capitalize', () {
      test(
        'should capitalize the first letter of a non-empty string',
        () => expect('hello'.capitalize(), equals('Hello')),
      );

      test(
        'should return an empty string for an empty string',
        () => expect(''.capitalize(), equals('')),
      );

      test(
        'should not capitalize the first letter of a string if it is an emoji',
        () => expect('🌎hello'.capitalize(), equals('🌎hello')),
      );
    });
  });
}
