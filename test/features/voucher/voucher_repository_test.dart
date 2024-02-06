import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/core/network/network_request_executor.dart';
import 'package:coffeecard/features/voucher_code.dart';
import 'package:coffeecard/generated/api/coffeecard_api_v2.swagger.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'voucher_repository_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<CoffeecardApiV2>(),
  MockSpec<NetworkRequestExecutor>(),
])
void main() {
  late MockCoffeecardApiV2 api;
  late MockNetworkRequestExecutor executor;
  late VoucherCodeRepository repository;

  setUp(() {
    executor = MockNetworkRequestExecutor();
    api = MockCoffeecardApiV2();
    repository = VoucherCodeRepository(api: api, executor: executor);

    provideDummy<TaskEither<Failure, SimplePurchaseResponse>>(
      TaskEither.left(const ConnectionFailure()),
    );
    provideDummy<Either<Failure, SimplePurchaseResponse>>(
      const Left(ConnectionFailure()),
    );
  });

  final testSimplePurchaseResponse = SimplePurchaseResponse(
    id: 0,
    productName: 'productName',
    productId: 0,
    numberOfTickets: 0,
    dateCreated: DateTime.parse('2023-27-05'),
    totalAmount: 10,
    purchaseStatus: null,
  );

  test(
    'GIVEN voucher code "a" is valid '
    'WHEN redeemVoucherCode("a") is called '
    'THEN the executor should be called and return Right(RedeemedVoucher)',
    () async {
      // arrange
      when(executor.executeAsTask<SimplePurchaseResponse>(any)).thenReturn(
        TaskEither.of(testSimplePurchaseResponse),
      );

      // act
      final actual = await repository.redeemVoucherCode('voucher').run();

      // assert
      verify(executor.executeAsTask<SimplePurchaseResponse>(any));
      expect(actual, isA<Right<Failure, RedeemedVoucher>>());
    },
  );

  test(
    'GIVEN voucher code "a" is invalid '
    'WHEN redeemVoucherCode("a") is called '
    'THEN the executor should be called and return some Failure in a Left',
    () async {
      // arrange
      when(executor.executeAsTask<SimplePurchaseResponse>(any)).thenReturn(
        TaskEither.left(const ServerFailure('Not found', 404)),
      );

      // act
      final actual = await repository.redeemVoucherCode('a').run();

      // assert
      verify(executor.executeAsTask<SimplePurchaseResponse>(any));
      expect(actual, isA<Left<Failure, RedeemedVoucher>>());
    },
  );
}
