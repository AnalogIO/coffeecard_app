import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/core/extensions/either_extensions.dart';
import 'package:coffeecard/features/purchase/data/repositories/payment_handler.dart';
import 'package:coffeecard/features/purchase/domain/entities/payment.dart';
import 'package:coffeecard/features/purchase/domain/entities/payment_status.dart';
import 'package:coffeecard/generated/api/coffeecard_api_v2.enums.swagger.dart';
import 'package:fpdart/fpdart.dart';

class FreeProductService extends PaymentHandler {
  const FreeProductService({
    required super.remoteDataSource,
    required super.buildContext,
  });

  @override
  Future<Either<Failure, Payment>> initPurchase(int productId) async {
    return remoteDataSource
        .initiatePurchase(
          productId,
          PaymentType.freepurchase,
        )
        .bindFuture(
          (purchase) => Payment(
            id: purchase.id,
            status: PaymentStatus.completed,
            deeplink: '',
            purchaseTime: purchase.dateCreated,
            price: purchase.totalAmount,
            productId: purchase.productId,
            productName: purchase.productName,
          ),
        );
  }
}
