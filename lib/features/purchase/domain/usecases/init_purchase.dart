import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/features/purchase/data/repositories/payment_handler.dart';
import 'package:coffeecard/features/purchase/domain/entities/payment.dart';
import 'package:fpdart/fpdart.dart';

class InitPurchase {
  final PaymentHandler paymentHandler;

  InitPurchase({required this.paymentHandler});

  Future<Either<Failure, Payment>> call(int productId) {
    return paymentHandler.initPurchase(productId);
  }
}
