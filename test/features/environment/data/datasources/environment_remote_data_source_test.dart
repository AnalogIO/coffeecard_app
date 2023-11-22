import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/core/network/network_request_executor.dart';
import 'package:coffeecard/features/environment/data/datasources/environment_remote_data_source.dart';
import 'package:coffeecard/features/environment/domain/entities/environment.dart';
import 'package:coffeecard/generated/api/coffeecard_api_v2.swagger.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'environment_remote_data_source_test.mocks.dart';

@GenerateMocks([CoffeecardApiV2, NetworkRequestExecutor])
void main() {
  late EnvironmentRemoteDataSource environmentRemoteDataSource;
  late MockCoffeecardApiV2 coffeecardApiV2;
  late MockNetworkRequestExecutor executor;

  setUp(() {
    coffeecardApiV2 = MockCoffeecardApiV2();
    executor = MockNetworkRequestExecutor();
    environmentRemoteDataSource = EnvironmentRemoteDataSource(
      apiV2: coffeecardApiV2,
      executor: executor,
    );

    provideDummy<Either<NetworkFailure, AppConfig>>(
      const Left(ConnectionFailure()),
    );
  });
  test('should call executor', () async {
    // arrange
    when(executor.execute<AppConfig>(any)).thenAnswer(
      (_) async => const Right(AppConfig(environmentType: 'Test')),
    );

    // act
    final actual = await environmentRemoteDataSource.getEnvironmentType();

    // assert
    expect(actual, const Right(Environment.test));
  });
}
