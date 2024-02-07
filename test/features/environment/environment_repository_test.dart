import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/core/network/network_request_executor.dart';
import 'package:coffeecard/features/environment.dart';
import 'package:coffeecard/generated/api/coffeecard_api_v2.swagger.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'environment_repository_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<CoffeecardApiV2>(),
  MockSpec<NetworkRequestExecutor>(),
])
void main() {
  late CoffeecardApiV2 apiV2;
  late NetworkRequestExecutor executor;
  late EnvironmentRepository repository;

  setUp(() {
    apiV2 = MockCoffeecardApiV2();
    executor = MockNetworkRequestExecutor();
    repository = EnvironmentRepository(apiV2: apiV2, executor: executor);
  });

  provideDummy(TaskEither<Failure, AppConfig>.left(const ConnectionFailure()));

  test(
    'GIVEN the API returns a Testing environment type '
    'WHEN getEnvironment is called '
    'THEN '
    '1) Executor.executeAsTask is called with apiV2.apiV2AppconfigGet, '
    '2) Environment.testing is returned in a Right',
    () async {
      // arrange
      when(executor.executeAsTask(apiV2.apiV2AppconfigGet))
          .thenReturn(TaskEither.of(const AppConfig(environmentType: 'Test')));

      // act
      final result = await repository.getEnvironment().run();

      // assert
      verify(executor.executeAsTask(apiV2.apiV2AppconfigGet)).called(1);
      verifyNoMoreInteractions(executor);
      expect(
        result,
        isA<Right<Failure, Environment>>()
            .having((r) => r.value, 'Environment', Environment.testing),
      );
    },
  );

  test(
    'GIVEN the API returns a Production environment type '
    'WHEN getEnvironment is called '
    'THEN '
    '1) Executor.executeAsTask is called with apiV2.apiV2AppconfigGet, '
    '2) Environment.production is returned in a Right',
    () async {
      // arrange
      when(executor.executeAsTask(apiV2.apiV2AppconfigGet)).thenReturn(
        TaskEither.of(const AppConfig(environmentType: 'Production')),
      );

      // act
      final result = await repository.getEnvironment().run();

      // assert
      verify(executor.executeAsTask(apiV2.apiV2AppconfigGet)).called(1);
      verifyNoMoreInteractions(executor);
      expect(
        result,
        isA<Right<Failure, Environment>>()
            .having((r) => r.value, 'Environment', Environment.production),
      );
    },
  );

  test(
    'GIVEN the API returns an unsupported environment type '
    'WHEN getEnvironment is called '
    'THEN '
    '1) Executor.executeAsTask is called with apiV2.apiV2AppconfigGet, '
    '2) UnknownFailure is returned in a Left',
    () async {
      // arrange
      when(executor.executeAsTask(apiV2.apiV2AppconfigGet)).thenReturn(
        TaskEither.of(const AppConfig(environmentType: 'LocalDevelopment')),
      );

      // act
      final result = await repository.getEnvironment().run();

      // assert
      verify(executor.executeAsTask(apiV2.apiV2AppconfigGet)).called(1);
      verifyNoMoreInteractions(executor);
      expect(
        result,
        isA<Left<Failure, Environment>>()
            .having((l) => l.value, 'Failure', isA<UnknownFailure>()),
      );
    },
  );
}
