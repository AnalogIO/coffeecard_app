import 'package:coffeecard/models/purchase/payment_status.dart';

class Payment {
  final int id;
  final String paymentId;
  final PaymentStatus status;
  final String deeplink;
  final int price;
  final DateTime purchaseTime;
  final String productName;

  Payment({
    required this.id,
    required this.price,
    required this.purchaseTime,
    required this.paymentId,
    required this.status,
    required this.deeplink,
    required this.productName,
  });

  Payment copyWith({
    int? id,
    String? paymentId,
    PaymentStatus? status,
    String? deeplink,
    int? price,
    DateTime? purchaseTime,
    String? productName,
  }) {
    return Payment(
      id: id ?? this.id,
      paymentId: paymentId ?? this.paymentId,
      status: status ?? this.status,
      deeplink: deeplink ?? this.deeplink,
      price: price ?? this.price,
      purchaseTime: purchaseTime ?? this.purchaseTime,
      productName: productName ?? this.productName,
    );
  }
}
