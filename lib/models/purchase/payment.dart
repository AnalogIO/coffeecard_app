import 'package:coffeecard/models/purchase/payment_status.dart';

class Payment {
  final int id;
  final String paymentId;
  final PaymentStatus status;
  final String deeplink;
  final int price;
  final DateTime purchaseTime;
  final int productId;
  final String productName;

  Payment({
    required this.id,
    required this.price,
    required this.purchaseTime,
    required this.paymentId,
    required this.status,
    required this.deeplink,
    required this.productId,
    required this.productName,
  });

  Payment copyWith({
    int? id,
    String? paymentId,
    PaymentStatus? status,
    String? deeplink,
    int? price,
    DateTime? purchaseTime,
    int? productId,
    String? productName,
  }) {
    return Payment(
      id: id ?? this.id,
      paymentId: paymentId ?? this.paymentId,
      status: status ?? this.status,
      deeplink: deeplink ?? this.deeplink,
      price: price ?? this.price,
      purchaseTime: purchaseTime ?? this.purchaseTime,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
    );
  }
}
