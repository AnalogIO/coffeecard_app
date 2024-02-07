import 'package:bloc_test/bloc_test.dart';
import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/features/environment.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'environment_cubit_test.mocks.dart';

@GenerateNiceMocks([MockSpec<EnvironmentRepository>()])
void main() {
  late EnvironmentRepository repository;
  late EnvironmentCubit cubit;

  setUp(() {
    repository = MockEnvironmentRepository();
    cubit = EnvironmentCubit(repository: repository);
  });

  provideDummy(
    TaskEither<Failure, Environment>.left(const ConnectionFailure()),
  );

  blocTest<EnvironmentCubit, EnvironmentState>(
    'GIVEN the repository returns a Testing environment type '
    'WHEN loadEnvironment is called '
    'THEN '
    '1) EnvironmentLoading is emitted '
    '2) EnvironmentLoaded is emitted with Environment.testing',
    build: () => cubit,
    setUp: () => when(repository.getEnvironment())
        .thenReturn(TaskEither.of(Environment.testing)),
    act: (cubit) => cubit.loadEnvironment(),
    expect: () => [
      const EnvironmentLoading(),
      const EnvironmentLoaded(Environment.testing),
    ],
  );

  blocTest<EnvironmentCubit, EnvironmentState>(
    'GIVEN the repository returns a Production environment type '
    'WHEN loadEnvironment is called '
    'THEN '
    '1) EnvironmentLoading is emitted '
    '2) EnvironmentLoaded is emitted with Environment.production',
    build: () => cubit,
    setUp: () => when(repository.getEnvironment())
        .thenReturn(TaskEither.of(Environment.production)),
    act: (cubit) => cubit.loadEnvironment(),
    expect: () => [
      const EnvironmentLoading(),
      const EnvironmentLoaded(Environment.production),
    ],
  );

  blocTest<EnvironmentCubit, EnvironmentState>(
    'GIVEN the repository returns a Failure '
    'WHEN loadEnvironment is called '
    'THEN '
    '1) EnvironmentLoading is emitted '
    '2) EnvironmentLoadError is emitted with the failure reason',
    build: () => cubit,
    setUp: () => when(repository.getEnvironment())
        .thenReturn(TaskEither.left(const UnknownFailure('a'))),
    act: (cubit) => cubit.loadEnvironment(),
    expect: () => [
      const EnvironmentLoading(),
      const EnvironmentLoadError('a'),
    ],
  );
}
