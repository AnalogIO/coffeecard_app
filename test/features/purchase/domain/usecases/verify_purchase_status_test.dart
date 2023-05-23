import 'package:coffeecard/features/purchase/data/repositories/payment_handler.dart';
import 'package:coffeecard/features/purchase/domain/entities/payment_status.dart';
import 'package:coffeecard/features/purchase/domain/usecases/verify_purchase_status.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'verify_purchase_status_test.mocks.dart';

@GenerateMocks([PaymentHandler])
void main() {
  late MockPaymentHandler paymentHandler;
  late VerifyPurchaseStatus usecase;

  setUp(() {
    paymentHandler = MockPaymentHandler();
    usecase = VerifyPurchaseStatus(paymentHandler: paymentHandler);
  });

  test('should call repository', () async {
    // arrange
    when(paymentHandler.verifyPurchase(any)).thenAnswer(
      (_) async => const Right(PaymentStatus.completed),
    );

    // act
    await usecase(0);

    // assert
    verify(paymentHandler.verifyPurchase(any));
    verifyNoMoreInteractions(paymentHandler);
  });
}
