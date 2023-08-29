import 'dart:convert';

import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/core/network/network_request_executor.dart';
import 'package:coffeecard/features/purchase/data/datasources/purchase_remote_data_source.dart';
import 'package:coffeecard/features/purchase/data/models/initiate_purchase_model.dart';
import 'package:coffeecard/features/purchase/data/models/single_purchase_model.dart';
import 'package:coffeecard/features/purchase/domain/entities/payment_status.dart';
import 'package:coffeecard/generated/api/coffeecard_api_v2.swagger.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'purchase_remote_data_source_test.mocks.dart';

@GenerateMocks([CoffeecardApiV2, NetworkRequestExecutor])
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

    provideDummy<Either<NetworkFailure, InitiatePurchaseResponse>>(
      const Left(ConnectionFailure()),
    );
    provideDummy<Either<NetworkFailure, SinglePurchaseResponse>>(
      const Left(ConnectionFailure()),
    );
  });

  group('initiatePurchase', () {
    test('should call executor', () async {
      // arrange
      when(executor.call<InitiatePurchaseResponse>(any)).thenAnswer(
        (_) async => Right(
          InitiatePurchaseResponse(
            dateCreated: DateTime.parse('2023-05-19'),
            id: 0,
            paymentDetails: json.decode(
              '{"mobilePayAppRedirectUri": "mobilePayAppRedirectUri", "paymentId": "paymentId", "state": "state", "discriminator": "discriminator", "paymentType": "paymentType", "orderId": "orderId"}',
            ),
            productId: 0,
            productName: 'productName',
            purchaseStatus: 'purchaseStatus',
            totalAmount: 0,
          ),
        ),
      );

      // act
      final actual = await purchaseRemoteDataSource.initiatePurchase(
        0,
        PaymentType.mobilepay,
      );

      // assert
      expect(
        actual,
        Right(
          InitiatePurchaseModel(
            dateCreated: DateTime.parse('2023-05-19'),
            id: 0,
            paymentDetails: MobilePayPaymentDetails(
              mobilePayAppRedirectUri: 'mobilePayAppRedirectUri',
              paymentId: 'paymentId',
              state: 'state',
              discriminator: 'discriminator',
              paymentType: 'paymentType',
              orderId: 'orderId',
            ).toJson(),
            productId: 0,
            productName: 'productName',
            purchaseStatus: 'purchaseStatus',
            totalAmount: 0,
          ),
        ),
      );
    });
  });

  group('getPurchase', () {
    test('should call executor', () async {
      // arrange
      when(executor.call<SinglePurchaseResponse>(any)).thenAnswer(
        (_) async => Right(
          SinglePurchaseResponse(
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
      final actual = await purchaseRemoteDataSource.getPurchase(0);

      // assert
      expect(
        actual,
        Right(
          SinglePurchaseModel(
            dateCreated: DateTime.parse('2023-05-19'),
            id: 0,
            status: PaymentStatus.completed,
            totalAmount: 0,
          ),
        ),
      );
    });
  });
}
