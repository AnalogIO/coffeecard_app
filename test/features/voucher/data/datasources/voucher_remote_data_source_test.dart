import 'package:coffeecard/core/network/network_request_executor.dart';
import 'package:coffeecard/features/voucher/data/datasources/voucher_remote_data_source.dart';
import 'package:coffeecard/features/voucher/data/models/redeemed_voucher_model.dart';
import 'package:coffeecard/generated/api/coffeecard_api.swagger.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'voucher_remote_data_source_test.mocks.dart';

@GenerateMocks([CoffeecardApi, NetworkRequestExecutor])
void main() {
  late VoucherRemoteDataSource remoteDataSource;
  late MockCoffeecardApi apiV1;
  late MockNetworkRequestExecutor executor;

  setUp(() {
    executor = MockNetworkRequestExecutor();
    apiV1 = MockCoffeecardApi();
    remoteDataSource = VoucherRemoteDataSource(
      apiV1: apiV1,
      executor: executor,
    );
  });

  group('redeemVoucher', () {
    test('should call executor', () async {
      // arrange
      when(executor.call<PurchaseDto>(any)).thenAnswer(
        (_) async => Right(
          PurchaseDto(
            id: 0,
            productName: 'productName',
            productId: 0,
            price: 0,
            numberOfTickets: 0,
            dateCreated: DateTime.parse('2023-27-05'),
            completed: true,
            orderId: 'orderId',
            transactionId: 'transactionId',
          ),
        ),
      );

      // act
      final actual = await remoteDataSource.redeemVoucher('voucher');

      // assert
      expect(
        actual,
        const Right(
          RedeemedVoucherModel(numberOfTickets: 0, productName: 'productName'),
        ),
      );
    });
  });
}
