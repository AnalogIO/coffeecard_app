import 'package:coffeecard/data/repositories/v2/purchase_repository.dart';
import 'package:coffeecard/models/api/api_error.dart';
import 'package:coffeecard/models/purchase/payment.dart';
import 'package:coffeecard/models/purchase/payment_status.dart';
import 'package:coffeecard/payment/mobilepay_service.dart';
import 'package:coffeecard/service_locator.dart';
import 'package:coffeecard/utils/either.dart';
import 'package:logger/logger.dart';

enum InternalPaymentType {
  mobilePay,
  applePay,
}

abstract class PaymentHandler {
  factory PaymentHandler(InternalPaymentType type) {
    switch (type) {
      case InternalPaymentType.mobilePay:
        return MobilePayService(sl.get<PurchaseRepository>(), sl.get<Logger>());
      case InternalPaymentType.applePay:
        throw UnimplementedError();
    }
  }

  Future<Either<ApiError, Payment>> initPurchase(int productId);

  Future<Either<ApiError, PaymentStatus>> verifyPurchase(int purchaseId);
}
