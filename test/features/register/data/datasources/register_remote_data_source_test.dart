import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/core/network/network_request_executor.dart';
import 'package:coffeecard/features/register/data/datasources/register_remote_data_source.dart';
import 'package:coffeecard/generated/api/coffeecard_api_v2.swagger.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'register_remote_data_source_test.mocks.dart';

@GenerateMocks([CoffeecardApiV2, NetworkRequestExecutor])
void main() {
  late MockCoffeecardApiV2 apiV2;
  late MockNetworkRequestExecutor executor;
  late RegisterRemoteDataSource dataSource;

  setUp(() {
    apiV2 = MockCoffeecardApiV2();
    executor = MockNetworkRequestExecutor();
    dataSource = RegisterRemoteDataSource(
      apiV2: apiV2,
      executor: executor,
    );

    provideDummy<Either<NetworkFailure, MessageResponseDto>>(
      const Left(ConnectionFailure()),
    );
    provideDummy<Either<NetworkFailure, Unit>>(const Left(ConnectionFailure()));
  });

  group('register', () {
    test('should call executor', () async {
      // arrange
      when(executor.executeAndDiscard<MessageResponseDto>(any)).thenAnswer(
        (_) async => const Right(unit),
      );

      // act
      await dataSource.register(
        'name',
        'email',
        'passcode',
        0,
      );

      // assert
      verify(executor.executeAndDiscard<MessageResponseDto>(any)).called(1);
    });
  });
}
