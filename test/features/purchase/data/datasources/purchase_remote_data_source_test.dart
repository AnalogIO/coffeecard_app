import 'package:coffeecard/core/network/network_request_executor.dart';
import 'package:coffeecard/features/purchase/data/datasources/purchase_remote_data_source.dart';
import 'package:coffeecard/features/purchase/data/models/payment_type.dart';
import 'package:coffeecard/generated/api/coffeecard_api_v2.swagger.dart'
    as swagger;
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'purchase_remote_data_source_test.mocks.dart';

@GenerateMocks([swagger.CoffeecardApiV2, NetworkRequestExecutor])
void main() {
  late PurchaseRemoteDataSource purchaseRemoteDataSource;
  late MockCoffeecardApiV2 apiV2;
  late MockNetworkRequestExecutor executor;

  setUp(() {
    apiV2 = MockCoffeecardApiV2();
    executor = MockNetworkRequestExecutor();
    purchaseRemoteDataSource = PurchaseRemoteDataSource(
      apiV2: apiV2,
      executor: executor,
    );
  });

  final testInitiatePurchaseResponse = swagger.InitiatePurchaseResponse(
    id: 0,
    dateCreated: DateTime.now(),
    productId: 0,
    productName: 'productName',
    totalAmount: 10,
    purchaseStatus: swagger.PurchaseStatus.pendingpayment,
    paymentDetails: swagger.MobilePayPaymentDetails.toJsonFactory(
      swagger.MobilePayPaymentDetails(
        paymentType: swagger.PaymentType.mobilepay,
        orderId: '',
        discriminator: '',
        mobilePayAppRedirectUri: '',
        paymentId: '',
        state: '',
      ),
    ),
  );

  group('initiatePurchase', () {
    test('should call executor', () async {
      // arrange
      when(executor.call<swagger.InitiatePurchaseResponse>(any)).thenAnswer(
        (_) async => right(testInitiatePurchaseResponse),
      );

      // act
      final _ = await purchaseRemoteDataSource.initiatePurchase(
        0,
        PaymentType.mobilepay,
      );

      // assert
      verify(executor.call<swagger.InitiatePurchaseResponse>(any)).called(1);
    });
  });

  group('getPurchase', () {
    test('should call executor', () async {
      // arrange
      when(executor.call<swagger.SinglePurchaseResponse>(any)).thenAnswer(
        (_) async => Right(
          swagger.SinglePurchaseResponse(
            dateCreated: DateTime.parse('2023-05-19'),
            id: 0,
            purchaseStatus: 'Completed',
            totalAmount: 0,
            productId: 0,
            paymentDetails: null,
          ),
        ),
      );

      // act
      final _ = await purchaseRemoteDataSource.getPurchase(0);

      // assert
      verify(executor.call<swagger.SinglePurchaseResponse>(any)).called(1);
    });
  });
}
