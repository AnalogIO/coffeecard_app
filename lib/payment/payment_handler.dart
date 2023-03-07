import 'package:coffeecard/data/repositories/utils/request_types.dart';
import 'package:coffeecard/data/repositories/v2/purchase_repository.dart';
import 'package:coffeecard/models/purchase/payment.dart';
import 'package:coffeecard/models/purchase/payment_status.dart';
import 'package:coffeecard/payment/mobilepay_service.dart';
import 'package:coffeecard/service_locator.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/widgets.dart';

enum InternalPaymentType {
  mobilePay,
}

abstract class PaymentHandler {
  factory PaymentHandler(InternalPaymentType type, BuildContext context) {
    switch (type) {
      case InternalPaymentType.mobilePay:
        return MobilePayService(sl.get<PurchaseRepository>(), context);
      default:
        throw UnimplementedError();
    }
  }

  Future<Either<RequestFailure, Payment>> initPurchase(int productId);

  Future<Either<RequestFailure, PaymentStatus>> verifyPurchase(int purchaseId);

  Future<void> invokePaymentMethod(Uri uri);
}
