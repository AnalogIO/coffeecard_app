import 'package:coffeecard/features/session/data/models/session_details_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';

void main() {
  final modelNullFields =
      SessionDetailsModel(sessionTimeout: none(), lastLogin: none());

  final model = SessionDetailsModel(
    sessionTimeout: some(const Duration(hours: 2)),
    lastLogin: some(DateTime(2023)),
  );

  group('fromJson', () {
    test('should parse model with null fields', () {
      // arrange
      final jsonString = {'last_login': 'null', 'session_timeout': 'null'};

      // act
      final actual = SessionDetailsModel.fromJson(jsonString);

      // assert
      expect(
        actual,
        modelNullFields,
      );
    });

    test('should parse model', () {
      // arrange
      final jsonString = {
        'last_login': '2023-01-01 00:00:00.000',
        'session_timeout': '2:00:00.000000',
      };

      // act
      final actual = SessionDetailsModel.fromJson(jsonString);

      // assert
      expect(
        actual,
        model,
      );
    });
  });

  group('toJson', () {
    test('should return map with null fields', () {
      // act
      final actual = modelNullFields.toJson();

      // assert
      expect(actual, {'last_login': 'null', 'session_timeout': 'null'});
    });

    test('should return map with fields', () {
      // act
      final actual = model.toJson();

      // assert
      expect(
        actual,
        {
          'last_login': '2023-01-01 00:00:00.000',
          'session_timeout': '2:00:00.000000',
        },
      );
    });
  });
}
