import 'package:coffeecard/core/network/executor.dart';
import 'package:coffeecard/features/opening_hours/opening_hours.dart';
import 'package:coffeecard/generated/api/shiftplanning_api.swagger.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'opening_hours_remote_data_source_test.mocks.dart';

@GenerateMocks([ShiftplanningApi, Executor])
void main() {
  late MockShiftplanningApi api;
  late MockExecutor executor;
  late OpeningHoursRemoteDataSource dataSource;

  setUp(() {
    api = MockShiftplanningApi();
    executor = MockExecutor();
    dataSource = OpeningHoursRemoteDataSourceImpl(api: api, executor: executor);
  });

  group('isOpen', () {
    test('should call executor', () async {
      // arrange
      when(executor(any)).thenAnswer(
        (_) async => IsOpenDTO(open: true),
      );

      // act
      final actual = await dataSource.isOpen();

      // assert
      expect(actual, true);
    });
  });

  group('getOpeningHours', () {
    test('should call executor', () async {
      // arrange
      final List<OpeningHoursDTO> tOpeningHours = [];

      when(executor(any)).thenAnswer(
        (_) async => tOpeningHours,
      );

      // act
      final actual = await dataSource.getOpeningHours();

      // assert
      expect(actual, tOpeningHours);
    });
  });
}
