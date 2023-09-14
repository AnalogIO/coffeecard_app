import 'package:coffeecard/core/external/date_service.dart';
import 'package:coffeecard/features/opening_hours/data/datasources/opening_hours_local_data_source.dart';
import 'package:coffeecard/features/opening_hours/data/repositories/opening_hours_repository_impl.dart';
import 'package:coffeecard/features/opening_hours/domain/entities/opening_hours.dart';
import 'package:coffeecard/features/opening_hours/domain/entities/timeslot.dart';
import 'package:coffeecard/features/opening_hours/domain/repositories/opening_hours_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'opening_hours_repository_impl_test.mocks.dart';

@GenerateMocks([OpeningHoursLocalDataSource, DateService])
void main() {
  late MockOpeningHoursLocalDataSource dataSource;
  late MockDateService dateService;
  late OpeningHoursRepository repository;

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
      const testOpeningHours = OpeningHours(
        allOpeningHours: {
          0: Timeslot(),
        },
        todaysOpeningHours: Timeslot(),
      );

      when(dataSource.getOpeningHours())
          .thenReturn(testOpeningHours.allOpeningHours);
      when(dateService.currentWeekday()).thenReturn(0);

      // act
      final actual = repository.getOpeningHours();

      // assert
      expect(actual, testOpeningHours);
    });
  });

  group('isOpen', () {
    test('should return [false] if today is closed', () {
      // arrange
      when(dataSource.getOpeningHours()).thenReturn({
        0: const Timeslot(),
      });
      when(dateService.currentWeekday()).thenReturn(0);

      // act
      final actual = repository.isOpen();

      // assert
      expect(actual, false);
    });

    test('should return [false] if current hour is before opening time', () {
      // arrange
      when(dataSource.getOpeningHours()).thenReturn({
        0: const Timeslot(start: 1, end: 2),
      });
      when(dateService.currentWeekday()).thenReturn(0);
      when(dateService.currentHour()).thenReturn(0);

      // act
      final actual = repository.isOpen();

      // assert
      expect(actual, false);
    });

    test('should return [false] if current hour is after closing time', () {
      when(dataSource.getOpeningHours()).thenReturn({
        0: const Timeslot(start: 1, end: 2),
      });
      when(dateService.currentWeekday()).thenReturn(0);
      when(dateService.currentHour()).thenReturn(3);

      // act
      final actual = repository.isOpen();

      // assert
      expect(actual, false);
    });

    test(
      'should return [true] if current hour is between opening and closing hour',
      () {
        when(dataSource.getOpeningHours()).thenReturn({
          0: const Timeslot(start: 0, end: 4),
        });
        when(dateService.currentWeekday()).thenReturn(0);
        when(dateService.currentHour()).thenReturn(2);

        // act
        final actual = repository.isOpen();

        // assert
        expect(actual, true);
      },
    );
  });
}
