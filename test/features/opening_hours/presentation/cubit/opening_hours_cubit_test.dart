import 'package:bloc_test/bloc_test.dart';
import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/features/opening_hours/domain/entities/opening_hours.dart';
import 'package:coffeecard/features/opening_hours/domain/entities/timeslot.dart';
import 'package:coffeecard/features/opening_hours/domain/usecases/get_opening_hours.dart';
import 'package:coffeecard/features/opening_hours/presentation/cubit/opening_hours_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'opening_hours_cubit_test.mocks.dart';

@GenerateMocks([GetOpeningHours])
void main() {
  late MockGetOpeningHours fetchOpeningHours;
  late OpeningHoursCubit cubit;

  setUp(() {
    fetchOpeningHours = MockGetOpeningHours();
    cubit = OpeningHoursCubit(fetchOpeningHours: fetchOpeningHours);

    provideDummy<Either<Failure, bool>>(
      const Left(ConnectionFailure()),
    );
    provideDummy<Either<Failure, Map<int, Timeslot>>>(
      const Left(ConnectionFailure()),
    );
  });

  group('getOpeninghours', () {
    const theOpeningHours = OpeningHours(
      allOpeningHours: {},
      todaysOpeningHours: Option.none(),
    );

    blocTest(
      'should emit [OpeningHoursLoaded]',
      build: () => cubit,
      setUp: () {
        when(fetchOpeningHours.call()).thenAnswer((_) => theOpeningHours);
      },
      act: (_) => cubit.getOpeninghours(),
      expect: () => [
        OpeningHoursLoaded(
          week: theOpeningHours.allOpeningHours,
          today: theOpeningHours.todaysOpeningHours,
        ),
      ],
    );
  });
}
