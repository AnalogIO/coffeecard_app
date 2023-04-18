import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/generated/api/coffeecard_api_v2.enums.swagger.dart';
import 'package:coffeecard/models/purchase/payment.dart';
import 'package:coffeecard/models/purchase/payment_status.dart';
import 'package:coffeecard/payment/payment_handler.dart';
import 'package:dartz/dartz.dart';

class FreeProductService extends PaymentHandler {
  const FreeProductService({
    required super.purchaseRepository,
    required super.context,
  });

  @override
  Future<Either<Failure, Payment>> initPurchase(int productId) async {
    final response = await purchaseRepository.initiatePurchase(
      productId,
      PaymentType.freepurchase,
    );

    return response.fold(
      (error) => Left(error),
      (purchase) => Right(
        Payment(
          id: purchase.id,
          status: PaymentStatus.completed,
          deeplink: '',
          purchaseTime: purchase.dateCreated,
          price: purchase.totalAmount,
          productId: purchase.productId,
          productName: purchase.productName,
        ),
      ),
    );
  }
}
