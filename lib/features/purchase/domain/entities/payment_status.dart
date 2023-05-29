import 'package:coffeecard/base/strings.dart';
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

  // TODO(marfavi): This should be moved into model?
  // FIXME: Create a GitHub issue for this.
  static PaymentStatus fromPurchaseStatus(PurchaseStatus status) {
    return switch (status) {
      PurchaseStatus.completed => PaymentStatus.completed,
      PurchaseStatus.cancelled => PaymentStatus.rejectedPayment,
      PurchaseStatus.pendingpayment => PaymentStatus.awaitingPayment,
      PurchaseStatus.refunded => PaymentStatus.refunded,
      PurchaseStatus.swaggerGeneratedUnknown => PaymentStatus.error,
    };
  }

  @override
  String toString() {
    return switch (this) {
      PaymentStatus.completed => Strings.paymentStatusCompleted,
      PaymentStatus.refunded => Strings.paymentStatusRefunded,
      PaymentStatus.awaitingPayment => Strings.paymentStatusAwaitingPayment,
      PaymentStatus.reserved => Strings.paymentStatusReserved,
      PaymentStatus.rejectedPayment ||
      PaymentStatus.error =>
        Strings.paymentStatusFailed,
    };
  }
}
