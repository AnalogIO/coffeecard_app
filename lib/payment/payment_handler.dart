import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/data/repositories/v2/purchase_repository.dart';
import 'package:coffeecard/models/purchase/payment.dart';
import 'package:coffeecard/models/purchase/payment_status.dart';
import 'package:coffeecard/payment/free_product_service.dart';
import 'package:coffeecard/payment/mobilepay_service.dart';
import 'package:coffeecard/service_locator.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/widgets.dart';

enum InternalPaymentType {
  mobilePay,
  applePay,
  free,
}

abstract class PaymentHandler {
  final PurchaseRepository _repository;
  // Certain implementations of the payment handler require access to the build context, even if it does not do so itself.
  // ignore: unused_field
  final BuildContext _context;

  const PaymentHandler({
    required PurchaseRepository repository,
    required BuildContext context,
  })  : _repository = repository,
        _context = context;

  static PaymentHandler createPaymentHandler(
    InternalPaymentType paymentType,
    BuildContext context,
  ) {
    final repository = sl.get<PurchaseRepository>();

    switch (paymentType) {
      case InternalPaymentType.mobilePay:
        return MobilePayService(repository: repository, context: context);
      case InternalPaymentType.free:
        return FreeProductService(repository: repository, context: context);
      default:
        throw UnimplementedError();
    }
  }

  Future<Either<Failure, Payment>> initPurchase(int productId);

  Future<Either<Failure, PaymentStatus>> verifyPurchase(
    int purchaseId,
  ) async {
    // Call API endpoint, receive PaymentStatus
    final either = await _repository.getPurchase(purchaseId);

    return either.map(
      (purchase) => purchase.status,
    );
  }
}
