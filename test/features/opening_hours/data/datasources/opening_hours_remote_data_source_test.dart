import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/features/opening_hours/opening_hours.dart';
import 'package:coffeecard/generated/api/shiftplanning_api.swagger.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../response_factory.dart';
import 'opening_hours_remote_data_source_test.mocks.dart';

@GenerateMocks([ShiftplanningApi])
void main() {
  late MockShiftplanningApi api;
  late OpeningHoursRemoteDataSource dataSource;

  setUp(() {
    api = MockShiftplanningApi();
    dataSource = OpeningHoursRemoteDataSource(api: api);
  });

  group('isOpen', () {
    test('should return [Left<ServerFailure>] if api call fails', () async {
      // arrange
      when(api.apiOpenShortKeyGet(shortKey: anyNamed('shortKey'))).thenAnswer(
        (_) async => ResponseFactory.fromStatusCode(500),
      );

      // act
      final actual = await dataSource.isOpen();

      // assert
      expect(actual, const TypeMatcher<Left<ServerFailure, bool>>());
    });

    test('should return [Right<bool>] if api call succeeds', () async {
      // arrange
      when(api.apiOpenShortKeyGet(shortKey: anyNamed('shortKey'))).thenAnswer(
        (_) async => ResponseFactory.fromStatusCode(
          200,
          body: IsOpenDTO(open: true),
        ),
      );

      // act
      final actual = await dataSource.isOpen();

      // assert
      expect(actual, const TypeMatcher<Right<ServerFailure, bool>>());
    });
  });

  group('getOpeningHours', () {
    test('should return [Left<ServerFailure>] if api call fails', () async {
      // arrange
      when(api.apiShiftsShortKeyGet(shortKey: anyNamed('shortKey'))).thenAnswer(
        (_) async => ResponseFactory.fromStatusCode(500),
      );

      // act
      final call = await dataSource.getOpeningHours();

      // assert
      expect(
        call,
        const TypeMatcher<Left<ServerFailure, List<OpeningHoursDTO>>>(),
      );
    });

    test('should return [Right<List<OpeningHoursDTO>>] if api call succeeds',
        () async {
      // arrange
      when(api.apiShiftsShortKeyGet(shortKey: anyNamed('shortKey'))).thenAnswer(
        (_) async => ResponseFactory.fromStatusCode(200, body: []),
      );

      // act
      final actual = await dataSource.getOpeningHours();

      // assert
      expect(
        actual,
        const TypeMatcher<Right<ServerFailure, List<OpeningHoursDTO>>>(),
      );
    });
  });
}
