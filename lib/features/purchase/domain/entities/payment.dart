import 'package:coffeecard/features/purchase/domain/entities/payment_status.dart';
import 'package:equatable/equatable.dart';

class Payment extends Equatable {
  final int id;
  final PaymentStatus status;
  final String deeplink;
  final int price;
  final DateTime purchaseTime;
  final int productId;
  final String productName;

  const Payment({
    required this.id,
    required this.price,
    required this.purchaseTime,
    required this.status,
    required this.deeplink,
    required this.productId,
    required this.productName,
  });

  Payment copyWith({
    int? id,
    PaymentStatus? status,
    String? deeplink,
    int? price,
    DateTime? purchaseTime,
    int? productId,
    String? productName,
  }) {
    return Payment(
      id: id ?? this.id,
      status: status ?? this.status,
      deeplink: deeplink ?? this.deeplink,
      price: price ?? this.price,
      purchaseTime: purchaseTime ?? this.purchaseTime,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
    );
  }

  @override
  List<Object?> get props => [
        id,
        status,
        deeplink,
        price,
        purchaseTime,
        productId,
        productName,
      ];
}
