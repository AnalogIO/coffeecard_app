import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/data/repositories/v2/purchase_repository.dart';
import 'package:coffeecard/models/purchase/payment.dart';
import 'package:coffeecard/models/purchase/payment_status.dart';
import 'package:coffeecard/payment/free_product_service.dart';
import 'package:coffeecard/payment/mobilepay_service.dart';
import 'package:coffeecard/service_locator.dart';
import 'package:flutter/widgets.dart';
import 'package:fpdart/fpdart.dart';

abstract class PaymentHandler {
  final PurchaseRepository purchaseRepository;
  // Certain implementations of the payment handler require access to the build context, even if it does not do so itself.
  final BuildContext context;

  const PaymentHandler({
    required this.purchaseRepository,
    required this.context,
  });

  static PaymentHandler createPaymentHandler(
    InternalPaymentType paymentType,
    BuildContext context,
  ) {
    final repository = sl.get<PurchaseRepository>();

    return switch (paymentType) {
      InternalPaymentType.mobilePay => MobilePayService(
          purchaseRepository: repository,
          context: context,
        ),
      InternalPaymentType.free => FreeProductService(
          purchaseRepository: repository,
          context: context,
        ),
    };
  }

  Future<Either<Failure, Payment>> initPurchase(int productId);

  Future<Either<Failure, PaymentStatus>> verifyPurchase(
    int purchaseId,
  ) async {
    // Call API endpoint, receive PaymentStatus
    final either = await purchaseRepository.getPurchase(purchaseId);

    return either.map(
      (purchase) => purchase.status,
    );
  }
}

enum InternalPaymentType {
  mobilePay,
  free,
}
