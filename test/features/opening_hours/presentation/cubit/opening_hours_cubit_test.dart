import 'package:bloc_test/bloc_test.dart';
import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/features/opening_hours/domain/entities/opening_hours.dart';
import 'package:coffeecard/features/opening_hours/opening_hours.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'opening_hours_cubit_test.mocks.dart';

@GenerateMocks([GetOpeningHours, CheckOpenStatus])
void main() {
  late MockGetOpeningHours getOpeningHours;
  late MockCheckOpenStatus checkOpenStatus;
  late OpeningHoursCubit cubit;

  setUp(() {
    getOpeningHours = MockGetOpeningHours();
    checkOpenStatus = MockCheckOpenStatus();
    cubit = OpeningHoursCubit(
      isOpen: checkOpenStatus,
      fetchOpeningHours: getOpeningHours,
    );
  });

  group('getOpeninghours', () {
    const theOpeningHours = OpeningHours(
      allOpeningHours: {},
      todaysOpeningHours: '',
    );

    blocTest(
      'should emit [Loading, Error] when isOpen fails',
      build: () => cubit,
      setUp: () => {
        when(checkOpenStatus(any)).thenAnswer(
          (_) => Future.value(const Left(ServerFailure('some error'))),
        ),
      },
      act: (_) async => cubit.getOpeninghours(),
      expect: () => [
        const OpeningHoursLoading(),
        const OpeningHoursError(error: 'some error'),
      ],
    );

    blocTest(
      'should emit [Loading, Error] when fetchOpeningHours fails',
      build: () => cubit,
      setUp: () {
        when(checkOpenStatus(any)).thenAnswer(
          (_) => Future.value(const Right(false)),
        );
        when(getOpeningHours(any)).thenAnswer(
          (_) => Future.value(const Left(ServerFailure('some error'))),
        );
      },
      act: (_) async => cubit.getOpeninghours(),
      expect: () => [
        const OpeningHoursLoading(),
        const OpeningHoursError(error: 'some error'),
      ],
    );

    blocTest(
      'should emit [Loading, Loaded] when isOpen and openingHours succeeds',
      build: () => cubit,
      setUp: () {
        when(checkOpenStatus(any)).thenAnswer(
          (_) => Future.value(const Right(true)),
        );
        when(getOpeningHours(any)).thenAnswer(
          (_) => Future.value(const Right(theOpeningHours)),
        );
      },
      act: (_) async => cubit.getOpeninghours(),
      expect: () => [
        const OpeningHoursLoading(),
        const OpeningHoursLoaded(
          isOpen: true,
          openingHours: {},
          todaysOpeningHours: '',
        ),
      ],
    );
  });
}
