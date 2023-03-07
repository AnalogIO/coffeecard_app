import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/features/opening_hours/domain/entities/opening_hours.dart';
import 'package:coffeecard/features/opening_hours/opening_hours.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'opening_hours_repository_impl_test.mocks.dart';

@GenerateMocks([OpeningHoursRemoteDataSource])
void main() {
  late MockOpeningHoursRemoteDataSource dataSource;
  late OpeningHoursRepositoryImpl repository;

  setUp(() {
    dataSource = MockOpeningHoursRemoteDataSource();
    repository = OpeningHoursRepositoryImpl(dataSource: dataSource);
  });

  group('getOpeningHours', () {
    test('should propagate error if data source call fails', () async {
      // arrange
      when(dataSource.getOpeningHours()).thenAnswer(
        (_) async => const Left(ServerFailure('some error')),
      );

      // act
      final actual = await repository.getOpeningHours(0);

      // assert
      expect(actual, const Left(ServerFailure('some error')));
    });

    test('should return map if data source call succeeds', () async {
      // arrange
      when(dataSource.getOpeningHours()).thenAnswer(
        (_) async => const Right([]),
      );

      // act
      final actual = await repository.getOpeningHours(DateTime.monday);

      // assert
      expect(
        actual,
        const Right(
          OpeningHours(
            allOpeningHours: {
              1: 'Closed',
              2: 'Closed',
              3: 'Closed',
              4: 'Closed',
              5: 'Closed',
              6: 'Closed',
              7: 'Closed',
            },
            todaysOpeningHours: 'Mondays: Closed',
          ),
        ),
      );
    });
  });

  group('calculateTodaysOpeningHours', () {
    test('should return correct hours given Monday', () {
      // arrange
      final openingHours = {DateTime.monday: '8 - 16'};

      // act
      final actual =
          repository.calculateTodaysOpeningHours(DateTime.monday, openingHours);

      // assert
      expect(actual, 'Mondays: 8 - 16');
    });

    test('should return correct hours given Tuesday', () {
      // arrange
      final openingHours = {DateTime.tuesday: '8 - 16'};

      // act
      final actual = repository.calculateTodaysOpeningHours(
        DateTime.tuesday,
        openingHours,
      );

      // assert
      expect(actual, 'Tuesdays: 8 - 16');
    });

    test('should return correct hours given Wednesday', () {
      // arrange
      final openingHours = {DateTime.wednesday: '8 - 16'};

      // act
      final actual = repository.calculateTodaysOpeningHours(
        DateTime.wednesday,
        openingHours,
      );

      // assert
      expect(actual, 'Wednesdays: 8 - 16');
    });

    test('should return correct hours given Thursday', () {
      // arrange
      final openingHours = {DateTime.thursday: '8 - 16'};

      // act
      final actual = repository.calculateTodaysOpeningHours(
        DateTime.thursday,
        openingHours,
      );

      // assert
      expect(actual, 'Thursdays: 8 - 16');
    });

    test('should return correct hours given Fridays', () {
      // arrange
      final openingHours = {DateTime.friday: '8 - 16'};

      // act
      final actual =
          repository.calculateTodaysOpeningHours(DateTime.friday, openingHours);

      // assert
      expect(actual, 'Fridays: 8 - 16');
    });

    test('should return correct hours given Saturday', () {
      // arrange
      final openingHours = {DateTime.saturday: '8 - 16'};

      // act
      final actual = repository.calculateTodaysOpeningHours(
        DateTime.saturday,
        openingHours,
      );

      // assert
      expect(actual, 'Saturdays: 8 - 16');
    });

    test('should return correct hours given Monday', () {
      // arrange
      final openingHours = {DateTime.sunday: '8 - 16'};

      // act
      final actual =
          repository.calculateTodaysOpeningHours(DateTime.sunday, openingHours);

      // assert
      expect(actual, 'Sundays: 8 - 16');
    });
  });
}
