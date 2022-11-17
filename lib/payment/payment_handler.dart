import 'package:coffeecard/data/repositories/utils/request_types.dart';
import 'package:coffeecard/data/repositories/v2/purchase_repository.dart';
import 'package:coffeecard/models/purchase/payment.dart';
import 'package:coffeecard/models/purchase/payment_status.dart';
import 'package:coffeecard/payment/mobilepay_service.dart';
import 'package:coffeecard/service_locator.dart';
import 'package:coffeecard/utils/either.dart';
import 'package:flutter/widgets.dart';

enum InternalPaymentType {
  mobilePay,
  applePay,
}

abstract class PaymentHandler {
  factory PaymentHandler(InternalPaymentType type, BuildContext context) {
    switch (type) {
      case InternalPaymentType.mobilePay:
        return MobilePayService(sl.get<PurchaseRepository>(), context);
      case InternalPaymentType.applePay:
        throw UnimplementedError();
    }
  }

  Future<Either<RequestError, Payment>> initPurchase(int productId);

  Future<Either<RequestError, PaymentStatus>> verifyPurchase(int purchaseId);
}
