import 'package:coffeecard/models/purchase/payment_status.dart';

class Payment {
  final int id;
  final String paymentId;
  final PaymentStatus status;
  final String deeplink;
  final int price;
  final DateTime purchaseTime;
  //TODO consider whether the product name should be added to the object.
  // Backend support would be required to pass it in a sensible manner

  Payment({
    required this.id,
    required this.price,
    required this.purchaseTime,
    required this.paymentId,
    required this.status,
    required this.deeplink,
  });
}
