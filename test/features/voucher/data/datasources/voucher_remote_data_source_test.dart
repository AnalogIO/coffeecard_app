import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/core/network/network_request_executor.dart';
import 'package:coffeecard/features/voucher/data/datasources/voucher_remote_data_source.dart';
import 'package:coffeecard/features/voucher/data/models/redeemed_voucher_model.dart';
import 'package:coffeecard/generated/api/coffeecard_api_v2.swagger.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'voucher_remote_data_source_test.mocks.dart';

@GenerateMocks([CoffeecardApiV2, NetworkRequestExecutor])
void main() {
  late VoucherRemoteDataSource remoteDataSource;
  late MockCoffeecardApiV2 apiV2;
  late MockNetworkRequestExecutor executor;

  setUp(() {
    executor = MockNetworkRequestExecutor();
    apiV2 = MockCoffeecardApiV2();
    remoteDataSource = VoucherRemoteDataSource(
      apiV2: apiV2,
      executor: executor,
    );

    provideDummy<Either<NetworkFailure, SimplePurchaseResponse>>(
      const Left(ConnectionFailure()),
    );
  });

  group('redeemVoucher', () {
    test('should call executor and map data', () async {
      // arrange
      when(executor.call<SimplePurchaseResponse>(any)).thenAnswer(
        (_) async => Right(
          SimplePurchaseResponse(
            id: 0,
            productName: 'productName',
            productId: 0,
            numberOfTickets: 0,
            dateCreated: DateTime.parse('2023-27-05'),
            totalAmount: 12,
            purchaseStatus: null,
          ),
        ),
      );

      // act
      final actual = await remoteDataSource.redeemVoucher('voucher');

      // assert
      verify(executor.call<SimplePurchaseResponse>(any));
      expect(
        actual,
        const Right(
          RedeemedVoucherModel(numberOfTickets: 0, productName: 'productName'),
        ),
      );
    });
  });
}
