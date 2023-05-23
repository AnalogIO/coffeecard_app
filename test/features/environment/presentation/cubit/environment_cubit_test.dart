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
  group('environment cubit tests', () {
    late EnvironmentCubit cubit;
    late MockGetEnvironmentType getEnvironmentType;

    setUp(() {
      getEnvironmentType = MockGetEnvironmentType();
      cubit = EnvironmentCubit(getEnvironmentType: getEnvironmentType);
    });

    test('initial state is EnvironmentInitial', () {
      expect(cubit.state, const EnvironmentInitial());
    });

    blocTest<EnvironmentCubit, EnvironmentState>(
      'getConfig emits Loaded when the repo returns a valid environment',
      build: () {
        when(getEnvironmentType(any))
            .thenAnswer((_) async => const Right(Environment.production));
        return cubit;
      },
      act: (cubit) => cubit.getConfig(),
      expect: () => [const EnvironmentLoaded(env: Environment.production)],
    );

    blocTest<EnvironmentCubit, EnvironmentState>(
      'getConfig emits Error when the repo returns an error',
      build: () {
        when(getEnvironmentType(any)).thenAnswer(
          (_) async => const Left(ServerFailure('some error')),
        );
        return cubit;
      },
      act: (cubit) => cubit.getConfig(),
      expect: () => [const EnvironmentError('some error')],
    );
  });
}
