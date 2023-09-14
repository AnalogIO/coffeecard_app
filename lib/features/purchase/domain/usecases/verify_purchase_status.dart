import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/features/purchase/data/repositories/payment_handler.dart';
import 'package:coffeecard/features/purchase/domain/entities/payment_status.dart';
import 'package:fpdart/fpdart.dart';

class VerifyPurchaseStatus {
  final PaymentHandler paymentHandler;

  VerifyPurchaseStatus({required this.paymentHandler});

  Future<Either<Failure, PaymentStatus>> call(int paymentId) {
    return paymentHandler.verifyPurchase(paymentId);
  }
}
