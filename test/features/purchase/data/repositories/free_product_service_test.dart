import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/features/purchase/data/datasources/purchase_remote_data_source.dart';
import 'package:coffeecard/features/purchase/data/repositories/free_product_service.dart';
import 'package:coffeecard/features/purchase/domain/entities/initiate_purchase.dart';
import 'package:coffeecard/features/purchase/domain/entities/payment.dart';
import 'package:coffeecard/features/purchase/domain/entities/payment_status.dart';
import 'package:coffeecard/generated/api/coffeecard_api_v2.swagger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'free_product_service_test.mocks.dart';

@GenerateMocks([PurchaseRemoteDataSource, BuildContext])
void main() {
  late FreeProductService freeProductService;
  late MockPurchaseRemoteDataSource remoteDataSource;
  late MockBuildContext buildContext;

  setUp(() {
    remoteDataSource = MockPurchaseRemoteDataSource();
    buildContext = MockBuildContext();
    freeProductService = FreeProductService(
      remoteDataSource: remoteDataSource,
      buildContext: buildContext,
    );

    provideDummy<Either<NetworkFailure, InitiatePurchase>>(
      const Left(ConnectionFailure()),
    );
  });

  group('initPurchase', () {
    test('should call remote data source', () async {
      // arrange
      when(remoteDataSource.initiatePurchase(any, any)).thenAnswer(
        (_) async => Right(
          InitiatePurchase(
            id: 0,
            totalAmount: 0,
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
            dateCreated: DateTime.parse('2023-05-19'),
          ),
        ),
      );

      // act
      final actual = await freeProductService.initPurchase(0);

      // assert
      expect(
        actual,
        Right(
          Payment(
            id: 0,
            price: 0,
            purchaseTime: DateTime.parse('2023-05-19'),
            status: PaymentStatus.completed,
            deeplink: '',
            productId: 0,
            productName: 'productName',
          ),
        ),
      );
    });
  });
}
