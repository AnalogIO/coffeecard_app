import 'package:coffeecard/core/external/date_service.dart';
import 'package:coffeecard/features/opening_hours/data/datasources/opening_hours_local_data_source.dart';
import 'package:coffeecard/features/opening_hours/data/repositories/opening_hours_repository_impl.dart';
import 'package:coffeecard/features/opening_hours/domain/repositories/opening_hours_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';

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
    test('should return [OpeningHours] with data from data source', () {});
  });

  group('isOpen', () {
    test('should return [false] if today is closed', () {});

    test('should return [false] if current hour is before opening time', () {});

    test('should return [false] if current hour is after closing time', () {});

    test(
      'should return [true] if current hour is between opening and closing hour',
      () {},
    );
  });
}
