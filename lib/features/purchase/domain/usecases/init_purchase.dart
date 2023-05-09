import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/core/usecases/usecase.dart';
import 'package:coffeecard/features/purchase/data/repositories/payment_handler.dart';
import 'package:coffeecard/features/purchase/domain/entities/payment.dart';
import 'package:dartz/dartz.dart';

class InitPurchase implements UseCase<Payment, int> {
  final PaymentHandler paymentHandler;

  InitPurchase({required this.paymentHandler});

  @override
  Future<Either<Failure, Payment>> call(int productId) {
    return paymentHandler.initPurchase(productId);
  }
}
