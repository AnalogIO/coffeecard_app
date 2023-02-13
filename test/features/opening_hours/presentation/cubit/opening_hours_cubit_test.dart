import 'package:bloc_test/bloc_test.dart';
import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/features/opening_hours/domain/usecases/fetch_opening_hours.dart';
import 'package:coffeecard/features/opening_hours/domain/usecases/is_open.dart';
import 'package:coffeecard/features/opening_hours/presentation/cubit/opening_hours_cubit.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'opening_hours_cubit_test.mocks.dart';

@GenerateMocks([FetchOpeningHours, GetIsOpen])
void main() {
  late MockFetchOpeningHours fetchOpeningHours;
  late MockGetIsOpen isOpen;
  late OpeningHoursCubit cubit;

  setUp(() {
    fetchOpeningHours = MockFetchOpeningHours();
    isOpen = MockGetIsOpen();
    cubit =
        OpeningHoursCubit(isOpen: isOpen, fetchOpeningHours: fetchOpeningHours);
  });

  group('getOpeninghours', () {
    blocTest(
      'should emit [Loading, Loaded] with status unknown when isOpen fails',
      build: () => cubit,
      setUp: () => {
        when(isOpen(any)).thenAnswer(
          (_) => Future.value(const Left(ServerFailure('some error'))),
        )
      },
      act: (_) async => cubit.getOpeninghours(),
      expect: () => [
        const OpeningHoursLoading(),
        const OpeningHoursLoaded(
          status: OpeningHoursStatus.unknown,
          openingHours: {},
        )
      ],
    );

    blocTest(
      'should emit [Loading, Error] when openingHours fails',
      build: () => cubit,
      setUp: () {
        when(isOpen(any)).thenAnswer(
          (_) => Future.value(const Right(false)),
        );
        when(fetchOpeningHours(any)).thenAnswer(
          (_) => Future.value(const Left(ServerFailure('some error'))),
        );
      },
      act: (_) async => cubit.getOpeninghours(),
      expect: () => [
        const OpeningHoursLoading(),
        const OpeningHoursLoaded(
          status: OpeningHoursStatus.closed,
          openingHours: {},
        )
      ],
    );

    blocTest(
      'should emit [Loading, Loaded] when isOpen and openingHours succeeds',
      build: () => cubit,
      setUp: () {
        when(isOpen(any)).thenAnswer(
          (_) => Future.value(const Right(true)),
        );
        when(fetchOpeningHours(any)).thenAnswer(
          (_) => Future.value(const Right({})),
        );
      },
      act: (_) async => cubit.getOpeninghours(),
      expect: () => [
        const OpeningHoursLoading(),
        const OpeningHoursLoaded(
          status: OpeningHoursStatus.open,
          openingHours: {},
        )
      ],
    );
  });
}
