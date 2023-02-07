import 'package:coffeecard/core/errors/exceptions.dart';
import 'package:coffeecard/features/opening_hours/data/datasources/opening_hours_remote_data_source.dart';
import 'package:coffeecard/generated/api/shiftplanning_api.swagger.dart';
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
    dataSource = OpeningHoursRemoteDataSourceImpl(api: api);
  });

  group('isOpen', () {
    test('should throw [ServerException] if api call fails', () async {
      // arrange
      when(api.apiOpenShortKeyGet(shortKey: anyNamed('shortKey'))).thenAnswer(
        (_) async => ResponseFactory.fromStatusCode(500),
      );

      // act
      final call = dataSource.isOpen;

      // assert
      expect(
        () async => call(),
        throwsA(const TypeMatcher<ServerException>()),
      );
    });

    test('should return bool if api call succeeds', () async {
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
      expect(actual, true);
    });
  });

  group('getOpeningHours', () {
    test('should throw [ServerException] if api call fails', () async {
      // arrange
      when(api.apiShiftsShortKeyGet(shortKey: anyNamed('shortKey'))).thenAnswer(
        (_) async => ResponseFactory.fromStatusCode(500),
      );

      // act
      final call = dataSource.getOpeningHours;

      // assert
      expect(
        () async => call(),
        throwsA(const TypeMatcher<ServerException>()),
      );
    });

    test('should return opening hours if api call succeeds', () {
      // arrange
      when(api.apiShiftsShortKeyGet(shortKey: anyNamed('shortKey'))).thenAnswer(
        (_) async => ResponseFactory.fromStatusCode(200, body: []),
      );

      // act
      final actual = dataSource.getOpeningHours();

      // assert
      expect(actual, []);
    });
  });
}
