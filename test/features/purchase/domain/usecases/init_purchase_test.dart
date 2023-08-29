import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/features/purchase/data/repositories/payment_handler.dart';
import 'package:coffeecard/features/purchase/domain/entities/payment.dart';
import 'package:coffeecard/features/purchase/domain/entities/payment_status.dart';
import 'package:coffeecard/features/purchase/domain/usecases/init_purchase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'init_purchase_test.mocks.dart';

@GenerateMocks([PaymentHandler])
void main() {
  late MockPaymentHandler paymentHandler;
  late InitPurchase usecase;

  setUp(() {
    paymentHandler = MockPaymentHandler();
    usecase = InitPurchase(paymentHandler: paymentHandler);

    provideDummy<Either<Failure, Payment>>(
      const Left(ConnectionFailure()),
    );
  });

  test('should call repository', () async {
    // arrange
    when(paymentHandler.initPurchase(any)).thenAnswer(
      (_) async => Right(
        Payment(
          id: 0,
          price: 0,
          purchaseTime: DateTime.now(),
          status: PaymentStatus.completed,
          deeplink: 'deeplink',
          productId: 0,
          productName: 'productName',
        ),
      ),
    );

    // act
    await usecase(0);

    // assert
    verify(paymentHandler.initPurchase(any));
    verifyNoMoreInteractions(paymentHandler);
  });
}
