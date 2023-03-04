import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/features/opening_hours/domain/entities/opening_hours.dart';
import 'package:coffeecard/features/opening_hours/opening_hours.dart';
import 'package:coffeecard/generated/api/shiftplanning_api.models.swagger.dart';
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

  group('getIsOpen', () {
    test('should return [Left<ServerFailure>] if data source call fails',
        () async {
      // arrange
      when(dataSource.isOpen())
          .thenAnswer((_) async => const Left(ServerFailure('some error')));

      // act
      final actual = await repository.getIsOpen();

      // assert
      expect(actual, isA<Left<ServerFailure, bool>>());
    });

    test('should return [Right<bool>] if data source call succeeds', () async {
      // arrange
      when(dataSource.isOpen()).thenAnswer((_) async => const Right(true));

      // act
      final actual = await repository.getIsOpen();

      // assert
      expect(actual, isA<Right<ServerFailure, bool>>());
    });
  });

  group('getOpeningHours', () {
    test('should return [Left<ServerFailure>] if data source call fails',
        () async {
      // arrange
      when(dataSource.getOpeningHours())
          .thenAnswer((_) async => const Left(ServerFailure('some error')));

      // act
      final actual = await repository.getOpeningHours(0);

      // assert
      expect(actual, isA<Left<ServerFailure, OpeningHours>>());
    });

    test('should return [Right<OpeningHours>] if data source call succeeds',
        () async {
      // arrange
      when(dataSource.getOpeningHours())
          .thenAnswer((_) async => const Right([]));

      // act
      final actual = await repository.getOpeningHours(DateTime.monday);

      // assert
      expect(actual, isA<Right<ServerFailure, OpeningHours>>());
    });

    test(
        'should return open Monday, all other days closed if data source call only returns shifts for Monday',
        () async {
      // arrange
      when(dataSource.getOpeningHours()).thenAnswer(
        (_) async => Right([
          OpeningHoursDTO(
            start: DateTime(2018, 1, 1, 8), // Monday, Jan 1, 2018, 8:00:00 AM
            end: DateTime(2018, 1, 1, 10), // Monday, Jan 1, 2018, 10:00:00 AM
            id: 1,
          )
        ]),
      );

      // act
      final actual = await repository.getOpeningHours(DateTime.monday);

      // assert
      const expected = Right(OpeningHours(
        allOpeningHours: {
          DateTime.monday: '08:00-10:00',
          DateTime.tuesday: 'Closed',
          DateTime.wednesday: 'Closed',
          DateTime.thursday: 'Closed',
          DateTime.friday: 'Closed',
          DateTime.saturday: 'Closed',
          DateTime.sunday: 'Closed',
        },
        todaysOpeningHours: 'Mondays: 08:00-10:00',
      ));
      expect(actual, expected);
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
