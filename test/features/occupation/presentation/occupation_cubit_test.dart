import 'package:bloc_test/bloc_test.dart';
import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/features/occupation/domain/usecases/get_occupations.dart';
import 'package:coffeecard/features/occupation/presentation/cubit/occupation_cubit.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'occupation_cubit_test.mocks.dart';

@GenerateMocks([GetOccupations])
void main() {
  late MockGetOccupations getOccupations;
  late OccupationCubit cubit;

  setUp(() {
    getOccupations = MockGetOccupations();
    cubit = OccupationCubit(
      getOccupations: getOccupations,
    );
  });

  group('fetchOccupations', () {
    blocTest(
      'should emit [Loading, Error] when use case fails',
      build: () => cubit,
      setUp: () => {
        when(getOccupations(any)).thenAnswer(
          (_) => Future.value(const Left(ServerFailure('some error'))),
        ),
      },
      act: (_) async => cubit.fetchOccupations(),
      expect: () => [
        const OccupationLoading(),
        const OccupationError(message: 'some error'),
      ],
    );

    blocTest(
      'should emit [Loading, Loaded] when use case succeeds',
      build: () => cubit,
      setUp: () => when(getOccupations(any)).thenAnswer(
        (_) => Future.value(const Right([])),
      ),
      act: (_) async => cubit.fetchOccupations(),
      expect: () => [
        const OccupationLoading(),
        const OccupationLoaded(occupations: []),
      ],
    );
  });
}
