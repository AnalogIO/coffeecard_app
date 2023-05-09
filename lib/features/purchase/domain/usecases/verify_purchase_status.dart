import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/core/usecases/usecase.dart';
import 'package:coffeecard/features/purchase/data/repositories/payment_handler.dart';
import 'package:coffeecard/features/purchase/domain/entities/payment_status.dart';
import 'package:dartz/dartz.dart';

class VerifyPurchaseStatus implements UseCase<PaymentStatus, int> {
  final PaymentHandler paymentHandler;

  VerifyPurchaseStatus({required this.paymentHandler});

  @override
  Future<Either<Failure, PaymentStatus>> call(int paymentId) {
    return paymentHandler.verifyPurchase(paymentId);
  }
}
