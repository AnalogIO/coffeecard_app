import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/core/network/network_request_executor.dart';
import 'package:coffeecard/features/product/data/datasources/product_remote_data_source.dart';
import 'package:coffeecard/features/receipt/data/datasources/receipt_remote_data_source.dart';
import 'package:coffeecard/generated/api/coffeecard_api_v2.swagger.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'receipt_remote_data_source_test.mocks.dart';

@GenerateMocks(
  [CoffeecardApiV2, ProductRemoteDataSource, NetworkRequestExecutor],
)
void main() {
  late ReceiptRemoteDataSource remoteDataSource;
  late MockCoffeecardApiV2 apiV2;
  late MockNetworkRequestExecutor executor;

  setUp(() {
    apiV2 = MockCoffeecardApiV2();
    executor = MockNetworkRequestExecutor();
    remoteDataSource = ReceiptRemoteDataSource(
      apiV2: apiV2,
      executor: executor,
    );

    provideDummy<Either<NetworkFailure, List<SimplePurchaseResponse>>>(
      const Left(ConnectionFailure()),
    );
    provideDummy<Either<NetworkFailure, List<TicketResponse>>>(
      const Left(ConnectionFailure()),
    );
  });

  group('getUsersUsedTicketsReceipts', () {
    test('should return [Left] if executor fails', () async {
      // arrange
      when(executor<List<TicketResponse>>(any))
          .thenAnswer((_) async => const Left(ServerFailure('some error')));

      // act
      final actual = await remoteDataSource.getUsersUsedTicketsReceipts();

      // assert
      expect(actual, const Left(ServerFailure('some error')));
    });

    test('should return [Right] if executor succeeds', () async {
      // arrange
      when(executor<List<TicketResponse>>(any))
          .thenAnswer((_) async => const Right([]));

      // act
      final actual = await remoteDataSource.getUsersUsedTicketsReceipts();

      // assert
      expect(actual.isRight(), true);
      actual.map((response) => expect(response, []));
    });
  });

  group('getUserPurchasesReceipts', () {
    test('should return [Left] if executor fails', () async {
      // arrange
      when(executor<List<SimplePurchaseResponse>>(any))
          .thenAnswer((_) async => const Left(ServerFailure('some error')));

      // act
      final actual = await remoteDataSource.getUserPurchasesReceipts();

      // assert
      expect(actual, const Left(ServerFailure('some error')));
    });

    test('should return [Right] if executor succeeds', () async {
      // arrange
      when(executor<List<SimplePurchaseResponse>>(any))
          .thenAnswer((_) async => const Right([]));

      // act
      final actual = await remoteDataSource.getUserPurchasesReceipts();

      // assert
      expect(actual.isRight(), true);
      actual.map((response) => expect(response, []));
    });
  });
}
