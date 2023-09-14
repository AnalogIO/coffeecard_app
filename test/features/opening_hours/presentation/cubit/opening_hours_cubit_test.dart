import 'package:bloc_test/bloc_test.dart';
import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/features/opening_hours/domain/entities/opening_hours.dart';
import 'package:coffeecard/features/opening_hours/domain/entities/timeslot.dart';
import 'package:coffeecard/features/opening_hours/domain/usecases/check_open_status.dart';
import 'package:coffeecard/features/opening_hours/domain/usecases/get_opening_hours.dart';
import 'package:coffeecard/features/opening_hours/presentation/cubit/opening_hours_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'opening_hours_cubit_test.mocks.dart';

@GenerateMocks([GetOpeningHours, CheckOpenStatus])
void main() {
  late MockGetOpeningHours fetchOpeningHours;
  late MockCheckOpenStatus checkIsOpen;
  late OpeningHoursCubit cubit;

  setUp(() {
    fetchOpeningHours = MockGetOpeningHours();
    checkIsOpen = MockCheckOpenStatus();
    cubit = OpeningHoursCubit(
      checkIsOpen: checkIsOpen,
      fetchOpeningHours: fetchOpeningHours,
    );

    provideDummy<Either<Failure, bool>>(
      const Left(ConnectionFailure()),
    );
    provideDummy<Either<Failure, Map<int, Timeslot>>>(
      const Left(ConnectionFailure()),
    );
  });

  group('getOpeninghours', () {
    final theOpeningHours =
        OpeningHours(allOpeningHours: {}, todaysOpeningHours: Timeslot());
    const isOpen = true;

    blocTest(
      'should emit [OpeningHoursLoaded]',
      build: () => cubit,
      setUp: () {
        when(fetchOpeningHours.call()).thenAnswer((_) => theOpeningHours);
        when(checkIsOpen.call()).thenAnswer((_) => isOpen);
      },
      act: (_) => cubit.getOpeninghours(),
      expect: () => [
        OpeningHoursLoaded(
          openingHours: theOpeningHours.allOpeningHours,
          todaysOpeningHours: theOpeningHours.todaysOpeningHours,
          isOpen: isOpen,
        ),
      ],
    );
  });
}
