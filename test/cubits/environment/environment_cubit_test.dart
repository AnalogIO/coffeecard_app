import 'package:bloc_test/bloc_test.dart';
import 'package:coffeecard/cubits/environment/environment_cubit.dart';
import 'package:coffeecard/data/repositories/utils/request_types.dart';
import 'package:coffeecard/data/repositories/v2/app_config_repository.dart';
import 'package:coffeecard/models/environment.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'environment_cubit_test.mocks.dart';

@GenerateMocks([AppConfigRepository])
void main() {
  group('environment cubit tests', () {
    late EnvironmentCubit environmentCubit;
    final repo = MockAppConfigRepository();

    setUp(() {
      environmentCubit = EnvironmentCubit(repo);
    });

    test('initial state is EnvironmentInitial', () {
      expect(environmentCubit.state, const EnvironmentInitial());
    });

    blocTest<EnvironmentCubit, EnvironmentState>(
      'getConfig emits Loaded when the repo returns a valid environment',
      build: () {
        when(repo.getEnvironmentType())
            .thenAnswer((_) async => const Right(Environment.production));
        return environmentCubit;
      },
      act: (cubit) => cubit.getConfig(),
      expect: () => [const EnvironmentLoaded(env: Environment.production)],
    );

    blocTest<EnvironmentCubit, EnvironmentState>(
      'getConfig emits Error when the repo returns an error',
      build: () {
        when(repo.getEnvironmentType()).thenAnswer(
          (_) async => Left(RequestHttpFailure('ERROR_MESSAGE', 0)),
        );
        return environmentCubit;
      },
      act: (cubit) => cubit.getConfig(),
      expect: () => [const EnvironmentError('ERROR_MESSAGE')],
    );

    tearDown(() {
      environmentCubit.close();
    });
  });
}
