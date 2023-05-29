import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/features/purchase/data/models/payment_type.dart';
import 'package:coffeecard/features/purchase/data/repositories/payment_handler.dart';
import 'package:coffeecard/features/purchase/domain/entities/payment.dart';
import 'package:fpdart/fpdart.dart';

class FreeProductService extends PaymentHandler {
  const FreeProductService({
    required super.remoteDataSource,
    required super.buildContext,
  });

  @override
  Future<Either<Failure, Payment>> initPurchase(int productId) {
    return remoteDataSource.initiatePurchase(
      productId,
      PaymentType.freepurchase,
    );
  }
}
