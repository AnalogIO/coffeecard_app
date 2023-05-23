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
    return switch (status) {
      PurchaseStatus.completed => PaymentStatus.completed,
      PurchaseStatus.cancelled => PaymentStatus.rejectedPayment,
      PurchaseStatus.pendingpayment => PaymentStatus.awaitingPayment,
      PurchaseStatus.refunded => PaymentStatus.refunded,
      PurchaseStatus.swaggerGeneratedUnknown => PaymentStatus.error,
    };
  }
}
