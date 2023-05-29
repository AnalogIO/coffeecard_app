import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/core/external/external_url_launcher.dart';
import 'package:coffeecard/features/purchase/data/datasources/purchase_remote_data_source.dart';
import 'package:coffeecard/features/purchase/data/repositories/mobilepay_service.dart';
import 'package:coffeecard/features/purchase/domain/entities/payment.dart';
import 'package:coffeecard/features/purchase/domain/entities/payment_status.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'mobilepay_service_test.mocks.dart';

@GenerateMocks([ExternalUrlLauncher, PurchaseRemoteDataSource, BuildContext])
void main() {
  late MobilePayService mobilePayService;
  late MockExternalUrlLauncher externalUrlLauncher;
  late MockPurchaseRemoteDataSource remoteDataSource;
  late MockBuildContext buildContext;

  setUp(() {
    externalUrlLauncher = MockExternalUrlLauncher();
    remoteDataSource = MockPurchaseRemoteDataSource();
    buildContext = MockBuildContext();
    mobilePayService = MobilePayService(
      externalUrlLauncher: externalUrlLauncher,
      remoteDataSource: remoteDataSource,
      buildContext: buildContext,
    );
  });

  const testError = 'some error';

  final testPayment = Payment(
    id: 0,
    status: PaymentStatus.awaitingPayment,
    deeplink: 'deeplink',
    price: 0,
    purchaseTime: DateTime.parse('2023-05-19'),
    productId: 0,
    productName: 'productName',
  );

  group('initPurchase', () {
    test('should return [Left] if remote data source fails', () async {
      // arrange
      when(remoteDataSource.initiatePurchase(any, any))
          .thenAnswer((_) async => const Left(ServerFailure(testError)));

      // act
      final actual = await mobilePayService.initPurchase(0);

      // assert
      expect(actual, const Left(ServerFailure(testError)));
    });

    test('should return [Right] if remote data source succeeds', () async {
      // arrange
      when(externalUrlLauncher.canLaunch(any)).thenAnswer((_) async => true);
      //when(externalUrlLauncher.launch(any)).thenAnswer((_) async {});
      when(remoteDataSource.initiatePurchase(any, any))
          .thenAnswer((_) async => Right(testPayment));

      // act
      final actual = await mobilePayService.initPurchase(0);

      // assert
      expect(actual, Right(testPayment));
    });
  });

  group('launchMobilePay', () {
    test(
      'should launch mobilepay link if application is able to launch',
      () async {
        // arrange
        when(externalUrlLauncher.canLaunch(any)).thenAnswer((_) async => true);

        // act
        await mobilePayService.launchMobilePay(testPayment);

        // assert
        verify(externalUrlLauncher.launch(any)).called(1);
      },
    );
  });
}
