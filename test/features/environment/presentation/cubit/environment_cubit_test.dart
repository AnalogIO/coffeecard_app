import 'package:bloc_test/bloc_test.dart';
import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/features/environment/domain/entities/environment.dart';
import 'package:coffeecard/features/environment/domain/usecases/get_environment_type.dart';
import 'package:coffeecard/features/environment/presentation/cubit/environment_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'environment_cubit_test.mocks.dart';

@GenerateMocks([GetEnvironmentType])
void main() {
  late EnvironmentCubit cubit;
  late MockGetEnvironmentType getEnvironmentType;

  setUp(() {
    getEnvironmentType = MockGetEnvironmentType();
    cubit = EnvironmentCubit(getEnvironmentType: getEnvironmentType);

    provideDummy<Either<Failure, Environment>>(
      const Left(ConnectionFailure()),
    );
  });

  test('initial state is [Initial]', () {
    expect(cubit.state, const EnvironmentInitial());
  });

  group('getConfig', () {
    blocTest(
      'should emit [Loaded] when usecase suceeds',
      build: () => cubit,
      setUp: () {
        when(getEnvironmentType())
            .thenAnswer((_) async => const Right(Environment.production));
      },
      act: (_) => cubit.getConfig(),
      expect: () => [const EnvironmentLoaded(env: Environment.production)],
    );

    blocTest(
      'should emit [Error] when usecase fails',
      build: () => cubit,
      setUp: () {
        when(getEnvironmentType()).thenAnswer(
          (_) async => const Left(ServerFailure('some error', 500)),
        );
      },
      act: (cubit) => cubit.getConfig(),
      expect: () => [const EnvironmentError('some error')],
    );
  });
}
