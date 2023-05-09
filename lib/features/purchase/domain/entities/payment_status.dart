import 'package:coffeecard/generated/api/coffeecard_api_v2.enums.swagger.dart';

enum PaymentStatus {
  /// Payment is completed
  completed,

  /// Payment errored out
  error,

  /// Payment is not yet complete
  reserved,

  /// User has not approved the purchase
  awaitingPayment,

  /// User has rejected payment
  rejectedPayment,

  /// Payment has been refunded
  refunded;

  static PaymentStatus fromPurchaseStatus(PurchaseStatus status) {
    switch (status) {
      case PurchaseStatus.swaggerGeneratedUnknown:
        return PaymentStatus.error;
      case PurchaseStatus.completed:
        return PaymentStatus.completed;
      case PurchaseStatus.cancelled:
        return PaymentStatus.rejectedPayment;
      case PurchaseStatus.pendingpayment:
        return PaymentStatus.awaitingPayment;
      case PurchaseStatus.refunded:
        return PaymentStatus.refunded;
    }
  }
}
