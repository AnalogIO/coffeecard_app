import 'package:coffeecard/core/external/date_service.dart';
import 'package:coffeecard/features/opening_hours/data/datasources/opening_hours_local_data_source.dart';
import 'package:coffeecard/features/opening_hours/data/repositories/opening_hours_repository_impl.dart';
import 'package:coffeecard/features/opening_hours/domain/entities/opening_hours.dart';
import 'package:coffeecard/features/opening_hours/domain/entities/timeslot.dart';
import 'package:coffeecard/features/opening_hours/domain/repositories/opening_hours_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'opening_hours_repository_impl_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<OpeningHoursLocalDataSource>(),
  MockSpec<DateService>(),
])
void main() {
  late MockOpeningHoursLocalDataSource dataSource;
  late MockDateService dateService;
  late OpeningHoursRepository repository;

  // test values

  // monday 13th of november 2023 at 12:00
  final mondayNoon = DateTime(2023, DateTime.november, 13, 12);

  const normalTimeslot = Timeslot(
    TimeOfDay(hour: 8, minute: 0),
    TimeOfDay(hour: 15, minute: 30),
  );
  final openMonday = {DateTime.monday: normalTimeslot};

  setUp(() {
    dataSource = MockOpeningHoursLocalDataSource();
    dateService = MockDateService();
    repository = OpeningHoursRepositoryImpl(
      dataSource: dataSource,
      dateService: dateService,
    );
  });

  group('getOpeningHours', () {
    test('should return [OpeningHours] with data from data source', () {
      // arrange
      when(dataSource.getOpeningHours()).thenReturn(openMonday);
      when(dateService.currentDateTime).thenReturn(mondayNoon);

      // act
      final actual = repository.getOpeningHours();

      // assert
      expect(
        actual,
        OpeningHours(
          allOpeningHours: openMonday,
          todaysOpeningHours: const Option.of(normalTimeslot),
        ),
      );
    });

    test('should return [OpeningHours] with empty [todaysOpeningHours]', () {
      // arrange
      when(dataSource.getOpeningHours()).thenReturn(openMonday);
      when(dateService.currentDateTime)
          .thenReturn(mondayNoon.copyWith(day: 14));

      // act
      final actual = repository.getOpeningHours();

      // assert
      expect(
        actual,
        OpeningHours(
          allOpeningHours: openMonday,
          todaysOpeningHours: const Option.none(),
        ),
      );
    });
  });

  group('isOpen', () {
    test('should return [false] if today is closed', () {
      // arrange
      when(dataSource.getOpeningHours()).thenReturn({});
      when(dateService.currentDateTime).thenReturn(mondayNoon);

      // act
      final actual = repository.isOpen();

      // assert
      expect(actual, false);
    });

    test('should return [false] if current hour is before opening time', () {
      when(dataSource.getOpeningHours()).thenReturn(openMonday);
      when(dateService.currentDateTime)
          .thenReturn(mondayNoon.copyWith(hour: 7));

      // act
      final actual = repository.isOpen();

      // assert
      expect(actual, false);
    });

    test('should return [false] if current hour is after closing time', () {
      when(dataSource.getOpeningHours()).thenReturn(openMonday);
      when(dateService.currentDateTime)
          .thenReturn(mondayNoon.copyWith(hour: 20));

      // act
      final actual = repository.isOpen();

      // assert
      expect(actual, false);
    });

    test(
      'should return [true] if current hour is between opening and closing hour',
      () {
        when(dataSource.getOpeningHours()).thenReturn(openMonday);
        when(dateService.currentDateTime).thenReturn(mondayNoon);

        // act
        final actual = repository.isOpen();

        // assert
        expect(actual, true);
      },
    );

    test(
      'should return [true] if current minute is between opening and closing minute',
      () {
        when(dataSource.getOpeningHours()).thenReturn(openMonday);
        when(dateService.currentDateTime)
            .thenReturn(mondayNoon.copyWith(hour: 15, minute: 15));

        // act
        final actual = repository.isOpen();

        // assert
        expect(actual, true);
      },
    );

    test(
      'should return [false] if current minute is before opening minute',
      () {
        when(dataSource.getOpeningHours()).thenReturn({
          DateTime.monday: const Timeslot(
            TimeOfDay(hour: 8, minute: 30),
            TimeOfDay(hour: 15, minute: 30),
          ),
        });
        when(dateService.currentDateTime)
            .thenReturn(mondayNoon.copyWith(hour: 8, minute: 15));

        // act
        final actual = repository.isOpen();

        // assert
        expect(actual, false);
      },
    );

    test(
      'should return [false] if current minute is after closing minute',
      () {
        when(dataSource.getOpeningHours()).thenReturn(openMonday);
        when(dateService.currentDateTime)
            .thenReturn(mondayNoon.copyWith(hour: 15, minute: 45));

        // act
        final actual = repository.isOpen();

        // assert
        expect(actual, false);
      },
    );
  });
}
