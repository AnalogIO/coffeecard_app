import 'package:bloc_test/bloc_test.dart';
import 'package:coffeecard/cubits/opening_hours/opening_hours_cubit.dart';
import 'package:coffeecard/data/repositories/shiftplanning/opening_hours_repository.dart';
import 'package:coffeecard/models/api/api_error.dart';
import 'package:coffeecard/utils/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'opening_hours_cubit_test.mocks.dart';

const dummyOpeningHours = {
  DateTime.monday: '00:00-00:00',
  DateTime.tuesday: '00:00-00:00',
  DateTime.wednesday: '00:00-00:00',
  DateTime.thursday: '00:00-00:00',
  DateTime.friday: '00:00-00:00',
  DateTime.saturday: '00:00-00:00',
  DateTime.sunday: '00:00-00:00',
};

@GenerateMocks([OpeningHoursRepository])
void main() {
  group('openinghours cubit tests', () {
    late OpeningHoursCubit openinghoursCubit;
    final repo = MockOpeningHoursRepository();

    setUp(() {
      openinghoursCubit = OpeningHoursCubit(repo);
    });

    blocTest<OpeningHoursCubit, OpeningHoursState>(
      'should emit loading and loaded when data is fetched successfully',
      build: () {
        when(repo.isOpen()).thenAnswer((_) async => const Right(true));
        when(repo.getOpeningHours())
            .thenAnswer((_) async => const Right(dummyOpeningHours));
        return openinghoursCubit;
      },
      act: (cubit) => cubit.getOpeninghours(),
      expect: () => [
        const OpeningHoursLoading(),
        const OpeningHoursLoaded(isOpen: true, openingHours: dummyOpeningHours),
      ],
    );

    blocTest<OpeningHoursCubit, OpeningHoursState>(
      'should emit loading and error when fetching repo.isOpen fails',
      build: () {
        when(repo.isOpen()).thenAnswer((_) async => Left(ApiError('ERROR')));
        when(repo.getOpeningHours())
            .thenAnswer((_) async => const Right(dummyOpeningHours));
        return openinghoursCubit;
      },
      act: (cubit) => cubit.getOpeninghours(),
      expect: () => [
        const OpeningHoursLoading(),
        const OpeningHoursError('ERROR'),
      ],
    );

    blocTest<OpeningHoursCubit, OpeningHoursState>(
      'should emit loading and error when fetching repo.getOpeningHours fails',
      build: () {
        when(repo.isOpen()).thenAnswer((_) async => const Right(true));
        when(repo.getOpeningHours())
            .thenAnswer((_) async => Left(ApiError('ERROR')));
        return openinghoursCubit;
      },
      act: (cubit) => cubit.getOpeninghours(),
      expect: () => [
        const OpeningHoursLoading(),
        const OpeningHoursError('ERROR'),
      ],
    );

    tearDown(() {
      openinghoursCubit.close();
    });
  });
}
