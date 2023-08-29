part of 'receipt.dart';

class PurchaseReceipt extends Receipt {
  final int price;
  final int amountPurchased;
  final PaymentStatus paymentStatus;

  const PurchaseReceipt({
    required super.productName,
    required super.timeUsed,
    required super.id,
    required this.price,
    required this.amountPurchased,
    required this.paymentStatus,
  });

  @override
  List<Object?> get props =>
      [productName, timeUsed, id, price, amountPurchased, paymentStatus];
}
